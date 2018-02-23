require "support/output_capturer"

RSpec.describe RspecOverview::Formatter, type: :formatter do
  include FormatterHelpers

  let(:output) { OutputCapturer.new }
  subject { described_class.new(output) }

  describe "summary by spec type" do
    it "groups examples by type and sums the execution run time" do
      examples = [
        example_double(metadata: { type: "feature" }, run_time: 1.5),
        example_double(metadata: { type: "feature" }, run_time: 0.5),
        example_double(metadata: { type: "model" }, run_time: 1.5),
      ]

      dump_examples_as_summary(subject, examples)

      expect(output.captures.first).to include "# Summary by Type or Subfolder"

      table = output_tables.first

      expect(table.column(0)).to eq ["Type or Subfolder", "feature", "model"]
      expect(table.column(1)).to eq ["Example count", 2, 1]
      expect(table.column(2)).to eq ["Duration (s)", "2", "1.5"]
      expect(table.column(3)).to eq ["Average per example (s)", "1", "1.5"]
    end

    it "uses the spec subfolder when a meta-type isn't available" do
      examples = [
        example_double(file_path: "./spec/foo/foo_spec.rb", run_time: 1.0),
        example_double(file_path: "./spec/foo/bar/bar_spec.rb", run_time: 1.0),
        example_double(file_path: "./spec/baz/baz_spec.rb", run_time: 1.0),
      ]

      dump_examples_as_summary(subject, examples)
      table = output_tables.first

      expect(table.column(0)).
        to eq ["Type or Subfolder", "./spec/foo", "./spec/baz"]

      expect(table.column(1)).to eq ["Example count", 2, 1]
      expect(table.column(2)).to eq ["Duration (s)", "2", "1"]
      expect(table.column(3)).to eq ["Average per example (s)", "1", "1"]
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

      expect(output.captures[3]).to include "# Summary by File"

      table = output_tables.last

      expect(table.column(0)).
        to eq ["File", "./spec/foo/foo_spec.rb", "./spec/baz/baz_spec.rb"]

      expect(table.column(1)).to eq ["Example count", 2, 1]
      expect(table.column(2)).to eq ["Duration (s)", "2.5", "1"]
      expect(table.column(3)).to eq ["Average per example (s)", "1.25", "1"]
    end
  end

  private

  def output_tables
    output.captures.select do |capture|
      capture.respond_to?(:column)
    end
  end
end
