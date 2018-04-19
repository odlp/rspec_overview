require "rspec/core"
require_relative "output/markdown_table"
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
      results = collate_by_identifier(examples) do |example|
        example.metadata[:type] || extract_subfolder(example.file_path)
      end

      summarize_by(identifier: "Type or Subfolder", results: results)
    end

    def summarize_by_file(examples)
      results = collate_by_identifier(examples) do |example|
        example.file_path
      end

      summarize_by(identifier: "File", results: results)
    end

    def collate_by_identifier(examples)
      examples.each_with_object({}) do |example, results|
        identifier = yield(example) || "none"
        results[identifier] ||= Result.new(identifier)
        results[identifier].example_count += 1
        results[identifier].duration_raw += example.execution_result.run_time
      end
    end

    def summarize_by(identifier:, results:)
      columns_attributes = {
        identifier => :identifier,
        "Example count" => :example_count,
        "Duration (s)" => :duration_seconds,
        "Average per example (s)" => :avg_duration_seconds,
      }

      output_body = output_format.new(
        headings: columns_attributes.keys,
        rows: results_as_rows(results.values, columns_attributes.values),
      )

      output.puts "\n# Summary by #{identifier}\n\n"
      output.puts output_body
      output.puts "\n"
    end

    def extract_subfolder(file_path)
      file_path.slice(/.\/[^\/]+\/[^\/]+/)
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
