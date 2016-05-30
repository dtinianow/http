require 'socket'
require 'pry'

class Server

attr_reader :tcp_server
attr_accessor :hello_count

  def initialize
    @tcp_server  = TCPServer.new(9292)
    @hello_count = 0
  end

  def output_client_messages(client, req)
    client.puts "Hello world (#{@hello_count})\n"
    client.puts req.join("\n")
    client.close
  end

  def client_request(client, request_lines)
    {:client => client, :req => request_lines}
  end

  def response
    loop do
      c_r = client_request(tcp_server.accept, [])
      while line = c_r[:client].gets and !line.chomp.empty?
        c_r[:req] << line.chomp
      end
      output_client_messages(c_r[:client], c_r[:req])
      self.hello_count += 1
    end
  end

end


server = Server.new
server.response
