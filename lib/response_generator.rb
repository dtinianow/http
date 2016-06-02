require './lib/word_search'
require './lib/parser'
require './lib/game'

class ResponseGenerator

  attr_reader :game

  def return_path_word_search(parsed_message, count)
    count[:total_requests] += 1
    WordSearch.new.check_dictionary(parsed_message.word)
  end

  def return_path_root(parsed_message, count)
    count[:total_requests] += 1
    "<pre>\n#{parsed_message.all_request_lines}\n</pre>"
  end

  def return_path_hello(count)
    count[:hellos] += 1
    count[:total_requests] += 1
    "Hello world (#{count[:hellos]})\n"
  end

  def return_path_datetime(count)
    count[:total_requests] += 1
    Time.new.strftime('%m:%M%p on %A, %B %e, %Y')
  end

  def return_path_shutdown(count)
    count[:total_requests] += 1
    tcp_server.close
    "Total Requests: #{count[:total_requests]}"
  end

  def return_path_unknown(count)
    count[:total_requests] += 1
    "404 Bro"
  end

  def return_path_start_game(count)
    count[:total_requests] += 1
    @game = Game.new
    "Good luck!"
  end

  def make_a_guess(input, count)
    count[:total_requests] += 1
    @game.guess = input
  end

  # def return_game_status
  #   #print guesses
  #   #return whether too high or low
  # end


end
