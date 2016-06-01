require './test/testhelper'
require './lib/server'
require './lib/response_generator'
require './lib/game'

class GameTest < Minitest::Test

  def test_guesses_keeps_track_of_guess_count
    game = Game.new
    assert_equal 0, game.guess_count
  end

  def test_guess_counter_increments
    game = Game.new
    assert_equal 0, game.guess_count
    game.guess_counter
    assert_equal 1, game.guess_count
  end

  def test_game_generates_a_solution
    game = Game.new
    assert game.solution <= 100
    assert game.solution >= 0
  end


end
