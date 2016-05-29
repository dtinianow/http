require 'socket'
require 'pry'

tcp_server = TCPServer.new(9292)


hellos = 0

loop do
  client = tcp_server.accept
  output = "Hello world (#{hellos})"
  client.puts output
  client.close
  hellos += 1
end
