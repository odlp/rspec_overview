class Result
  attr_reader :identifier
  attr_accessor :example_count, :duration_raw

  def initialize(identifier)
    @identifier = identifier
    @example_count = 0
    @duration_raw = 0.0
  end

  def avg_duration_seconds
    format_seconds(duration_raw / example_count)
  end

  def duration_seconds
    format_seconds(duration_raw)
  end

  private

  def format_seconds(duration)
    RSpec::Core::Formatters::Helpers.format_seconds(duration)
  end
end
