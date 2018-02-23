require "csv"

module RspecOverview
  module Output
    class Csv
      def initialize(headings:, rows:)
        @headings = headings
        @rows = rows
      end

      def to_s
        csv_content
      end

      private

      attr_reader :headings, :rows

      def csv_content
        CSV.generate(**csv_options, headers: headings) do |csv|
          rows.each { |row| csv << row }
        end
      end

      def csv_options
        { write_headers: true, force_quotes: true }
      end
    end
  end
end
