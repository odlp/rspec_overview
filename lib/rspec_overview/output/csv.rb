require "csv"

module RspecOverview
  module Output
    class Csv
      def generate(output:, title:, headings:, rows:)
        csv_string = CSV.generate(**csv_options, headers: headings) do |csv|
          rows.each { |row| csv << row }
        end

        output.puts title
        output.puts csv_string
      end

      private

      def csv_options
        { write_headers: true, force_quotes: true }
      end
    end
  end
end
