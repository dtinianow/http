class Game

  attr_reader :solution
  attr_accessor :guess, :guess_count

  def initialize
    @guess = 0
    @guess_count = 0
    @solution = rand(0..100)
  end

  def evaluate_guess(guess)
    if guess == solution
      "Correct!"
    elsif guess > solution
      "Your guess is too high."
    else
      "Your guess is too low."
    end
  end

end
