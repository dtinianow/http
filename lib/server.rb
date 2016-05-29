require 'socket'

class Server

  attr_reader :client, :tcp_server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = @tcp_server.accept
  end

end

server = Server.new

request_lines = []
while line = server.client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

hello_requests = 0
hello_requests += 1

puts "Hello World (#{hello_requests})"

output = "<html><head></head><body>Hello World (#{hello_requests})</body></html>"

server.client.puts output

server.client.close
