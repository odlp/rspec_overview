require_relative "result"

module RspecOverview
  class ResultsCollator
    def self.by_identifier(examples)
      examples.each_with_object({}) do |example, results|
        identifier = yield(example) || "none"
        results[identifier] ||= Result.new(identifier)
        results[identifier].example_count += 1
        results[identifier].duration_raw += example.execution_result.run_time
      end.values
    end
  end
end
