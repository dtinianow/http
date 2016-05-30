require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :hello_count

  def initialize
    @tcp_server    = TCPServer.new(9292)
    @hello_count   = 0
  end

  def response
    while client = tcp_server.accept
      request = get_request(client)
      output_client_messages(client, request)
      @hello_count += 1
    end
  end

  def get_request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def output_client_messages(client, request)
    client.puts "Hello world (#{@hello_count})\n"
    client.puts request.join("\n")
    client.close
  end

end


server = Server.new
server.response
