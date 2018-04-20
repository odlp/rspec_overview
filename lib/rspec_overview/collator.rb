require_relative "result"

module RspecOverview
  class Collator
    def by_type_or_subfolder(examples)
      by_identifier(examples) do |example|
        example.metadata[:type] || extract_subfolder(example.file_path)
      end
    end

    def by_file_path(examples)
      by_identifier(examples) do |example|
        example.file_path
      end
    end

    private

    def by_identifier(examples)
      examples.each_with_object({}) do |example, results|
        identifier = yield(example) || "none"
        results[identifier] ||= Result.new(identifier)
        results[identifier].example_count += 1
        results[identifier].duration_raw += example.execution_result.run_time
      end.values
    end

    def extract_subfolder(file_path)
      file_path.slice(/.\/[^\/]+\/[^\/]+/)
    end
  end
end
