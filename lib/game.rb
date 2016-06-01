class Game

  attr_reader :guess_count, :solution

  def initialize
    @guess_count = 0
    @solution = rand(0..100)
  end

  def guess_counter
    @guess_count += 1
  end


end
