require "csv"

module RspecOverview
  module Output
    class Csv
      def initialize(headings:, rows:)
        @headings = headings
        @rows = rows
      end

      def to_s
        CSV.generate(**csv_options, headers: headings) do |csv|
          rows.each { |row| csv << row }
        end
      end

      private

      attr_reader :headings, :rows

      def csv_options
        { write_headers: true, force_quotes: true }
      end
    end
  end
end
