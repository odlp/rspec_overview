require "matrix"

module RspecOverview
  module Output
    class MarkdownTable
      BORDER_SEPERATOR = "|".freeze
      NOT_BORDER_SEPERATOR = /[^#{BORDER_SEPERATOR}]/
      HEADING_SEPERATOR = "-".freeze

      def initialize(headings:, rows:)
        @matrix = Matrix.rows([headings] + rows)
      end

      def to_s
        render_table
      end

      def column(index)
        matrix.column(index).to_a
      end

      private

      attr_reader :matrix

      def render_table
        lines = matrix.row_vectors.map(&method(:render_row))
        lines.insert(1, create_heading_divider(lines.first))
        lines.join("\n") + "\n"
      end

      def render_row(data_row)
        table_row = [BORDER_SEPERATOR]

        data_row.each_with_index do |value, column_index|
          table_row << " #{pad_value(value, column_index)} #{BORDER_SEPERATOR}"
        end

        table_row.join
      end

      def create_heading_divider(line)
        line.gsub(NOT_BORDER_SEPERATOR, HEADING_SEPERATOR)
      end

      def pad_value(value, column_index)
        column_width = width_of_column(column_index)
        value.to_s.ljust(column_width, " ")
      end

      def width_of_column(index)
        column(index).max_by{ |value| value.to_s.length }.length
      end
    end
  end
end
