class OutputCapturer
  attr_reader :captures

  def initialize
    @captures = []
  end

  def puts(obj)
    captures << obj
  end
end
