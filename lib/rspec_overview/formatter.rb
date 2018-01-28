require "rspec/core"
require "terminal-table"
require_relative "result_row"

module RspecOverview
  class Formatter < ::RSpec::Core::Formatters::ProgressFormatter
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

      headings = [
        column_name, "Example count", "Duration (s)", "Average per example (s)"
      ]

      rows = values_in_descending_duration(data).map do |row|
        [
          row.identifier,
          row.example_count,
          helpers.format_seconds(row.duration_raw),
          helpers.format_seconds(row.avg_duration),
        ]
      end

      output.puts "\nSummary by #{column_name}"
      print_table(headings: headings, rows: rows)
    end

    def type_or_subfolder(example)
      example.metadata[:type] || example.file_path.slice(/.\/[^\/]+\/[^\/]+/)
    end

    def values_in_descending_duration(data)
      data.values.sort_by(&:duration_raw).reverse_each
    end

    def helpers
      RSpec::Core::Formatters::Helpers
    end

    def print_table(headings:, rows:)
      output.puts Terminal::Table.new(headings: headings, rows: rows)
    end
  end
end
