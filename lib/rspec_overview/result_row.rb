class ResultRow
  attr_reader :identifier
  attr_accessor :example_count, :duration_raw

  def initialize(identifier)
    @identifier = identifier
    @example_count = 0
    @duration_raw = 0.0
  end

  def avg_duration
    duration_raw / example_count
  end
end
