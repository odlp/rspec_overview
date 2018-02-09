require "rspec/core"
require_relative "output/table"
require_relative "result"

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
      summarize_by("Type or Subfolder", examples) do |example|
        example.metadata[:type] || extract_subfolder(example.file_path)
      end
    end

    def summarize_by_file(examples)
      summarize_by("File", examples) { |example| example.file_path }
    end

    def summarize_by(column_name, examples)
      results = {}

      examples.each do |example|
        identifier = yield(example) || "none"
        results[identifier] ||= Result.new(identifier)
        results[identifier].example_count += 1
        results[identifier].duration_raw += example.execution_result.run_time
      end

      headings = [
        column_name, "Example count", "Duration (s)", "Average per example (s)"
      ]

      output_format.generate(
        output: output,
        title: "Summary by #{column_name}",
        headings: headings,
        rows: results_as_rows(results),
      )
    end

    def extract_subfolder(file_path)
      file_path.slice(/.\/[^\/]+\/[^\/]+/)
    end

    def results_as_rows(results)
      results.values
        .sort_by(&:duration_raw)
        .reverse_each
        .map(&:to_a)
    end

    def output_format
      RspecOverview::Output::Table.new
    end
  end
end
