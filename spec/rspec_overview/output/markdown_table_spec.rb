require "rspec_overview/output/markdown_table"

RSpec.describe RspecOverview::Output::MarkdownTable do
  it "generates a markdown table" do
    table = described_class.new(
      headings: ["Heading", "Longer Heading", "Short"],
      rows: [
        ["Longer row 1A", "Row 1B", "1C"],
        ["Row 2A", "Row 2B", "2C"],
      ]
    )

    expect(table.to_s).to eq <<~TABLE
      | Heading       | Longer Heading | Short |
      |---------------|----------------|-------|
      | Longer row 1A | Row 1B         | 1C    |
      | Row 2A        | Row 2B         | 2C    |
    TABLE
  end

  it "handles nil cell values" do
    table = described_class.new(
      headings: ["Heading", "Optional"],
      rows: [
        ["1A", "1B"],
        ["2A", nil],
        ["3A", "3B"],
      ]
    )

    expect(table.to_s).to eq <<~TABLE
      | Heading | Optional |
      |---------|----------|
      | 1A      | 1B       |
      | 2A      |          |
      | 3A      | 3B       |
    TABLE
  end
end
