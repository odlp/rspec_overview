require_relative "output/csv"

module RspecOverview
  class FormatterCsv < Formatter
    RSpec::Core::Formatters.register self, :dump_summary

    private

    def output_format
      RspecOverview::Output::Csv
    end
  end
end
