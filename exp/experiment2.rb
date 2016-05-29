require 'socket'
tcp_server = TCPServer.new(9292)
client = tcp_server.accept


request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

hello_requests = 0
hello_requests += 1

puts "Hello World (#{hello_requests})"

output = "<html><head></head><body>Hello World (#{hello_requests})</body></html>"

client.puts output

# client.close
