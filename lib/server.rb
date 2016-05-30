require_relative 'parser'
require 'socket'
require 'pry'

class Server

attr_reader :tcp_server

  def initialize
    @tcp_server    = TCPServer.new(9292)
  end

  def start
    while client = tcp_server.accept
      request = get_request(client)
      parsed_message = Parser.new(request, tcp_server)
      output_client_messages(client, parsed_message)
    end
  end

  def get_request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def output_client_messages(client, parsed_message)

    # client.puts @parsed_message.first_request_line
    # client.puts @parsed_message.remaining_request_lines
    # client.puts @parsed_message.last_request_line
    # client.puts "\n"
    # client.puts @parsed_message.request
    client.puts parsed_message.check_path
    client.close
  end

end


server = Server.new
server.start
