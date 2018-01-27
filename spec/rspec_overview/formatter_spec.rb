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

      expect(output.captures.first).to eq "\nSummary by Type or Subfolder"

      table = output.captures[1]

      expect(table.column_with_headings(0)).
        to eq ["Type or Subfolder", "feature", "model"]

      expect(table.column_with_headings(1)).
        to eq ["Example count", 2, 1]

      expect(table.column_with_headings(2)).
        to eq ["Duration (s)", "2", "1.5"]

      expect(table.column_with_headings(3)).
        to eq ["Average per example (s)", "1", "1.5"]
    end

    it "uses the spec subfolder when a meta-type isn't available" do
      examples = [
        example_double(file_path: "./spec/foo/foo_spec.rb", run_time: 1.0),
        example_double(file_path: "./spec/foo/bar/bar_spec.rb", run_time: 1.0),
        example_double(file_path: "./spec/baz/baz_spec.rb", run_time: 1.0),
      ]

      dump_examples_as_summary(subject, examples)

      table = output.captures[1]

      expect(table.column_with_headings(0)).
        to eq ["Type or Subfolder", "./spec/foo", "./spec/baz"]

      expect(table.column_with_headings(1)).
        to eq ["Example count", 2, 1]

      expect(table.column_with_headings(2)).
        to eq ["Duration (s)", "2", "1"]

      expect(table.column_with_headings(3)).
        to eq ["Average per example (s)", "1", "1"]
    end
  end

  describe "summary by file" do
    it "groups examples by file path and sums the execution run time" do
      examples = [
        example_double(file_path: "./spec/foo/foo_spec.rb", run_time: 1.0),
        example_double(file_path: "./spec/foo/foo_spec.rb", run_time: 1.5),
        example_double(file_path: "./spec/baz/baz_spec.rb", run_time: 1.0),
      ]

      dump_examples_as_summary(subject, examples)

      expect(output.captures[2]).to eq "\nSummary by File"

      table = output.captures[3]

      expect(table.column_with_headings(0)).
        to eq ["File", "./spec/foo/foo_spec.rb", "./spec/baz/baz_spec.rb"]

      expect(table.column_with_headings(1)).
        to eq ["Example count", 2, 1]

      expect(table.column_with_headings(2)).
        to eq ["Duration (s)", "2.5", "1"]

      expect(table.column_with_headings(3)).
        to eq ["Average per example (s)", "1.25", "1"]
    end
  end

  private

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

  def dump_examples_as_summary(subjekt, examples)
    summary = instance_double(
      RSpec::Core::Notifications::SummaryNotification,
      examples: examples,
    )

    subjekt.dump_summary(summary)
  end
end
