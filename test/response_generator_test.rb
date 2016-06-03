require './test/testhelper'
require './lib/server'
require './lib/response_generator'

class ResponseGeneratorTest < Minitest::Test

  def test_hello_count_works
    r = ResponseGenerator.new
    assert_equal 0, r.count[:hellos]
    r.return_path_hello
    assert_equal 1, r.count[:hellos]
  end

  def test_datetime_path
    r = ResponseGenerator.new
    assert_equal Time.new.strftime('%l:%M%p on %A, %B %e, %Y'), r.return_path_datetime
    assert_equal 1, r.count[:total_requests]
  end

  def test_unknown_path
    r = ResponseGenerator.new
    assert_equal "404 Bro", r.return_path_unknown
    assert_equal 1, r.count[:total_requests]
  end

  def test_total_requests_between_pages
    r = ResponseGenerator.new
    assert_equal 0, r.count[:total_requests]
    r.return_path_unknown
    assert_equal 1, r.count[:total_requests]
    r.return_path_hello
    assert_equal 2, r.count[:total_requests]
    r.return_path_datetime
    assert_equal 3, r.count[:total_requests]
  end

  def test_start_game_path
    r = ResponseGenerator.new
    assert_equal "Good luck!", r.return_path_start_game
    assert_equal 1, r.count[:total_requests]
  end

  def test_return_path_make_a_guess_stores_a_guess
    r = ResponseGenerator.new
    r.return_path_start_game
    assert_equal 10, r.make_a_guess(10)
  end

  def test_return_game_status_returns_guess_count
    r = ResponseGenerator.new
    r.return_path_start_game
    r.make_a_guess(10)
    r.make_a_guess(43)
    expected = "Your guess count is 2."
    assert r.return_game_status.include?(expected)
  end

  def test_return_redirect_displays_a_redirect_message
    r = ResponseGenerator.new
    assert_equal "302 Redirecting", r.return_redirect
  end

  def test_reset_response_code_sets_default_values
    r = ResponseGenerator.new
    r.return_path_start_game
    r.make_a_guess(50)
    r.reset_response_code
    assert_equal "200 OK", r.code
    assert_equal "pizza", r.address
  end

end
