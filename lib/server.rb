require './lib/parser'
require './lib/word_search'
require './lib/response_generator'
require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :response

  def initialize(start = false)
    @tcp_server    = TCPServer.new(9292) if start
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

  def check_path
    response.reset_response_code
    case @parsed_message.path.downcase
      when "/"
        response.return_path_root(@parsed_message)
      when "/hello"
        response.return_path_hello
      when "/datetime"
        response.return_path_datetime
      when "/shutdown"
        response.return_path_shutdown(tcp_server)
      when "/word_search"
        response.return_path_word_search(@parsed_message)
      when "/start_game"
        if @parsed_message.verb_is_post?
          if response.game_in_progress
            response.return_path_403_forbidden
          else
            response.return_path_start_game
          end
        else
          response.return_path_404_unknown
        end
      when "/game"
        if @parsed_message.verb_is_post?
          response.make_a_guess(@input)
          response.return_path_302_redirect
        else
          response.return_game_status
        end
      when "/force_error"
        response.return_path_500_error
      else
        response.return_path_404_unknown
      end
  end

  def output_client_messages(client)
    output = check_path
    @headers = ["HTTP/1.1 #{response.code}",
      "location: #{response.address}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts @headers
      client.puts output
      client.close
    end
end

if __FILE__ == $0
  server = Server.new(true)
  server.start
end
