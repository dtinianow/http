require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :hello_count

  def initialize
    @tcp_server    = TCPServer.new(9292)
    @hello_count   = 0
  end

  def output_client_messages(client, req)
    client.puts "Hello world (#{@hello_count})\n"
    client.puts req.join("\n")
    client.close
  end

  def response
    loop do
      client = tcp_server.accept
      request_lines = []
        while line = client.gets and !line.chomp.empty?
          request_lines << line.chomp
        end
      output_client_messages(client, request_lines)
      @hello_count += 1
    end
  end

end


server = Server.new
server.response
