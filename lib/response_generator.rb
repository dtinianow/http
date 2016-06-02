require './lib/word_search'
require './lib/parser'
require './lib/game'

class ResponseGenerator

  attr_reader :game, :count, :address, :code

  def initialize
    @count   = {hellos: 0, total_requests: 0}
    @code    = "200 OK"
    @address = "pizza"
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

  def return_path_unknown
    count[:total_requests] += 1
    "404 Bro"
  end

  def return_path_start_game
    count[:total_requests] += 1
    @game = Game.new
    "Good luck!"
  end

  def make_a_guess(input)
    @code = "302 MOVED"
    @address = "http://127.0.0.1:9292/game"
    @game.guess_count += 1
    @game.guess = input.to_i
  end

  def return_game_status
    count[:total_requests] += 1
    "#{@game.evaluate_guess(@game.guess)}\nYour guess count is #{@game.guess_count}."
  end

  def return_redirect
    "302 Redirecting"
  end

  def reset_response_code
    @code    = "200 OK"
    @address = "pizza"
  end

end
