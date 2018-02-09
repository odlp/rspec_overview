require "terminal-table"

module RspecOverview
  module Output
    class Table
      def generate(output:, title:, headings:, rows:)
        output.puts "\n"
        output.puts Terminal::Table.new(
          title: title,
          headings: headings,
          rows: rows,
        )
      end
    end
  end
end
