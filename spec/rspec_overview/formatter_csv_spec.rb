require "support/output_capturer"
require "csv"

RSpec.describe RspecOverview::FormatterCsv, type: :formatter do
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

      expect(output.captures[0]).to eq "Summary by Type or Subfolder"

      csv = CSV.parse(output.captures[1], headers: true)

      expect(csv.by_col["Type or Subfolder"]).
        to eq ["feature", "model"]

      expect(csv.by_col["Example count"]).
        to eq ["2", "1"]

      expect(csv.by_col["Duration (s)"]).
        to eq ["2", "1.5"]

      expect(csv.by_col["Average per example (s)"]).
        to eq ["1", "1.5"]
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

      expect(output.captures[2]).to eq "Summary by File"

      csv = CSV.parse(output.captures[3], headers: true)

      expect(csv.by_col["File"]).
        to eq ["./spec/foo/foo_spec.rb", "./spec/baz/baz_spec.rb"]

      expect(csv.by_col["Example count"]).
        to eq ["2", "1"]

      expect(csv.by_col["Duration (s)"]).
        to eq ["2.5", "1"]

      expect(csv.by_col["Average per example (s)"]).
        to eq ["1.25", "1"]
    end
  end
end
