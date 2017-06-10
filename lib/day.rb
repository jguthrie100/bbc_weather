class Day
  attr_accessor :high, :low, :date, :sunrise, :sunset, :hours

  def initialize
    @hours = Hash.new
  end
end
