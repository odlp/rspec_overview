class OutputCapturer
  attr_reader :captures

  def initialize
    self.captures = []
  end

  def puts(obj)
    self.captures << obj
  end

  private

  attr_writer :captures
end
