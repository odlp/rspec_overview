require "support/output_capturer"

RSpec.describe RspecOverview::Formatter do
  let(:output) { OutputCapturer.new }
  subject { described_class.new(output) }

  it "extends the progress formatter" do
    progress_formatter = RSpec::Core::Formatters::ProgressFormatter
    expect(described_class.ancestors).to include progress_formatter
  end

  describe "summary by spec type" do
    it "groups examples by type and sums the execution run time" do
      examples = [
        example_double(metadata: { type: "feature" }, run_time: 1.5),
        example_double(metadata: { type: "feature" }, run_time: 0.5),
        example_double(metadata: { type: "model" }, run_time: 1.5),
      ]

      dump_examples_as_summary(subject, examples)

      expect(output.captures.first).to eq "\nSummary by Type"

      table = output.captures[1]

      expect(table.column_with_headings(0)).
        to eq ["Type", "feature", "model"]

      expect(table.column_with_headings(1)).
        to eq ["Example count", 2, 1]

      expect(table.column_with_headings(2)).
        to eq ["Duration (s)", "2", "1.5"]

      expect(table.column_with_headings(3)).
        to eq ["Average per example (s)", "1", "1.5"]
    end
  end

  private

  def example_double(metadata: {}, run_time: 0.0)
    execution_result = instance_double(
      RSpec::Core::Example::ExecutionResult,
      run_time: run_time,
    )

    instance_double(
      RSpec::Core::Example,
      metadata: metadata,
      execution_result: execution_result,
    )
  end

  def dump_examples_as_summary(subjekt, examples)
    summary = instance_double(
      RSpec::Core::Notifications::SummaryNotification,
      examples: examples,
    )

    subjekt.dump_summary(summary)
  end
end
