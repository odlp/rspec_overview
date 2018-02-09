module FormatterHelpers
  def example_double(metadata: {}, run_time: 0.0, file_path: "")
    execution_result = instance_double(
      RSpec::Core::Example::ExecutionResult,
      run_time: run_time,
    )

    instance_double(
      RSpec::Core::Example,
      metadata: metadata,
      file_path: file_path,
      execution_result: execution_result,
    )
  end

  def summary_double(examples:)
    instance_double(
      RSpec::Core::Notifications::SummaryNotification,
      examples: examples,
    )
  end

  def dump_examples_as_summary(formatter, examples)
    formatter.dump_summary(summary_double(examples: examples))
  end
end
