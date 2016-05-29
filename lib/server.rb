require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :client, :hello_count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_count = 0
  end

  # def request_lines(client)
  # request_lines = []
  #   while line = client.gets and !line.chomp.empty?
  #     request_lines << line.chomp
  #   end
  # end

  def response
    loop do
      client = tcp_server.accept
      request_lines = []
        while line = client.gets and !line.chomp.empty?
          request_lines << line.chomp
        end
      client.puts "Hello world (#{@hello_count})\n"
      client.puts request_lines.join("\n")
      client.close
      @hello_count += 1
    end
  end

end


server = Server.new
server.response
