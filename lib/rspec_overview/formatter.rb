require "rspec/core"
require_relative "output/markdown_table"
require_relative "results_collator"

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
      output_summary(
        identifier: "Type or Subfolder",
        results: ResultsCollator.new.by_type_or_subfolder(examples),
      )
    end

    def summarize_by_file(examples)
      output_summary(
        identifier: "File",
        results: ResultsCollator.new.by_file_path(examples),
      )
    end

    def output_summary(identifier:, results:)
      columns_attributes = {
        identifier => :identifier,
        "Example count" => :example_count,
        "Duration (s)" => :duration_seconds,
        "Average per example (s)" => :avg_duration_seconds,
      }

      output_body = output_format.new(
        headings: columns_attributes.keys,
        rows: results_as_rows(results, columns_attributes.values),
      )

      output.puts "\n# Summary by #{identifier}\n\n"
      output.puts output_body
      output.puts "\n"
    end

    def results_as_rows(results, attributes)
      results.sort_by(&:duration_raw).reverse_each.map do |result|
        attributes.map { |attribute| result.public_send(attribute) }
      end
    end

    def output_format
      RspecOverview::Output::MarkdownTable
    end
  end
end
