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
    end

    private

    attr_reader :output

    def summarize_by_type(examples)
      summarize_by(examples, column_name: "Type or Subfolder") do |example|
        example.metadata[:type] ||
          example.file_path.slice(/.\/[^\/]+\/[^\/]+/) ||
          "none"
      end
    end

    def summarize_by(examples, column_name:)
      data = {}

      examples.each do |example|
        identifier = yield(example)
        data[identifier] ||= ResultRow.new(identifier)
        data[identifier].example_count += 1
        data[identifier].duration_raw += example.execution_result.run_time
      end

      headings = [
        column_name, "Example count", "Duration (s)", "Average per example (s)"
      ]

      rows = in_descending_duration(data).map do |_, row|
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

    def in_descending_duration(data)
      data.sort_by { |_, row| row.duration_raw }.reverse_each
    end

    def helpers
      RSpec::Core::Formatters::Helpers
    end

    def print_table(headings:, rows:)
      output.puts Terminal::Table.new(headings: headings, rows: rows)
    end
  end
end
