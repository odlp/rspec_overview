require "rspec/core"
require_relative "output/table"
require_relative "result_row"

module RspecOverview
  class Formatter
    RSpec::Core::Formatters.register self, :dump_summary

    def initialize(output)
      @output = output
    end

    def dump_summary(summary)
      summarize_by_type(summary.examples)
      summarize_by_file(summary.examples)
    end

    private

    attr_reader :output

    def summarize_by_type(examples)
      summarize_by("Type or Subfolder", examples, &method(:type_or_subfolder))
    end

    def summarize_by_file(examples)
      summarize_by("File", examples) { |example| example.file_path }
    end

    def summarize_by(column_name, examples)
      data = {}

      examples.each do |example|
        identifier = yield(example) || "none"
        data[identifier] ||= ResultRow.new(identifier)
        data[identifier].example_count += 1
        data[identifier].duration_raw += example.execution_result.run_time
      end

      title = "Summary by #{column_name}"

      headings = [
        column_name, "Example count", "Duration (s)", "Average per example (s)"
      ]

      rows = values_in_descending_duration(data).map(&method(:as_table_row))

      output_format.generate(
        output: output,
        title: title,
        headings: headings,
        rows: rows,
      )
    end

    def type_or_subfolder(example)
      example.metadata[:type] || example.file_path.slice(/.\/[^\/]+\/[^\/]+/)
    end

    def values_in_descending_duration(data)
      data.values.sort_by(&:duration_raw).reverse_each
    end

    def as_table_row(row)
      [
        row.identifier,
        row.example_count,
        format_seconds(row.duration_raw),
        format_seconds(row.avg_duration),
      ]
    end

    def format_seconds(duration)
      RSpec::Core::Formatters::Helpers.format_seconds(duration)
    end

    def output_format
      RspecOverview::Output::Table.new
    end
  end
end
