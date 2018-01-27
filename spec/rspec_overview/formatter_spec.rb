RSpec.describe RspecOverview::Formatter do
  it "extends the progress formatter" do
    progress_formatter = RSpec::Core::Formatters::ProgressFormatter
    expect(described_class.ancestors).to include progress_formatter
  end
end
