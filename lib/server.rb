require './lib/parser'
require './lib/word_search'
require './lib/response_generator'
require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :count, :response

  def initialize(start = false)
    @tcp_server    = TCPServer.new(9292) if start
    @count         = {hellos: 0, total_requests: 0}
    @response      = ResponseGenerator.new
  end

  def start
    while client = tcp_server.accept
      request = get_request(client)
      @parsed_message = Parser.new(request)
      output_client_messages(client)
    end
  end

  def get_request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    @input = client.read(request_lines[3].split(" ")[1].to_i)
    request_lines
  end

  def output_client_messages(client)
    output = check_path
    headers = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    client.close
  end

  def check_path
    case @parsed_message.path.downcase
      when "/"
        response.return_path_root(@parsed_message, count)
      when "/hello"
        response.return_path_hello(count)
      when "/datetime"
        response.return_path_datetime(count)
      when "/shutdown"
        response.return_path_shutdown(count)
      when "/word_search"
        response.return_path_word_search(@parsed_message, count)
      when "/start_game"
        if @parsed_message.verb_is_post?
          response.return_path_start_game(count)
        else
          response.return_path_unknown(count)
        end
      when "/game"
        if @parsed_message.verb_is_post?
          response.make_a_guess(@input)
          response.return_game_status(count)
        else
          response.return_game_status(count)
        end
      else
        response.return_path_unknown(count)
      end
  end

end

if __FILE__ == $0
  server = Server.new(true)
  server.start
end
