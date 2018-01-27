require "rspec/core"

module RspecOverview
  class Formatter < ::RSpec::Core::Formatters::ProgressFormatter
    RSpec::Core::Formatters.register self, :dump_summary

    def initialize(output)
      @output = output
    end

    private

    attr_reader :output
  end
end
