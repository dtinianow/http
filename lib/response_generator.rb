require './lib/word_search'
require './lib/parser'
require './lib/game'

class ResponseGenerator

  attr_reader :game, :count, :address, :code, :game_in_progress

  def initialize
    @count   = {hellos: 0, total_requests: 0}
    @code    = "200 OK"
    @address = "pizza"
    @game_in_progress = false
  end

  def return_path_word_search(parsed_message)
    count[:total_requests] += 1
    WordSearch.new.check_dictionary(parsed_message.word)
  end

  def return_path_root(parsed_message)
    count[:total_requests] += 1
    "<pre>\n#{parsed_message.all_request_lines}\n</pre>"
  end

  def return_path_hello
    count[:hellos] += 1
    count[:total_requests] += 1
    "Hello world (#{count[:hellos]})\n"
  end

  def return_path_datetime
    count[:total_requests] += 1
    Time.new.strftime('%l:%M%p on %A, %B %e, %Y')
  end

  def return_path_shutdown(server)
    count[:total_requests] += 1
    server.close
    "Total Requests: #{count[:total_requests]}"
  end


  def return_path_start_game
    count[:total_requests] += 1
    @game = Game.new
    @game_in_progress = true
    "Good luck!"
  end

  def make_a_guess(input)
    count[:total_requests] += 1
    @game.guess_count += 1
    @game.guess = input.to_i
  end

  def return_game_status
    count[:total_requests] += 1
    "#{@game.evaluate_guess(@game.guess)}\nYour guess count is #{@game.guess_count}."
  end

  def reset_response_code
    @code    = "200 OK"
    @address = "pizza"
  end

  def return_path_302_redirect
    @address = "http://127.0.0.1:9292/game"
    @code = "302 MOVED"
    "302 Redirecting"
  end

  def return_path_403_forbidden
    count[:total_requests] += 1
    @code = "403 Forbidden"
    "403 Forbidden"
  end

  def return_path_404_unknown
    count[:total_requests] += 1
    @code = "404 Not Found"
    "404 Not Found"
  end

  # def return_path_500_error
  #   count[:total_requests] += 1
  #   @code = "500 Internal Server Error"
  #   "OH SNAP, SOMETHING BROKE ON THE SERVER!"
  #   raise SystemStackError, caller
  # end
end
