require_relative 'parser'
require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :count

  def initialize
    @tcp_server    = TCPServer.new(9292)
    @count = {hellos: -1, total_requests: 0}
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
    request_lines
  end

  def output_client_messages(client)
    # response = "<pre>" + request.join("\n") + "</pre>"
    output = check_path
    # "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    # client.puts @parsed_message.first_request_line
    # client.puts @parsed_message.remaining_request_lines
    # client.puts @parsed_message.last_request_line
    # client.puts "\n"
    # client.puts @parsed_message.request
    # client.puts check_path
    client.close
  end

  def root_output
    @parsed_message.request.join("\r\n")
  end

  def check_path
    case @parsed_message.path.downcase
      when "/"
        count[:total_requests] += 1
        "<pre>\n#{root_output}\n</pre>"
      when "/hello"
        count[:hellos] += 1
        count[:total_requests] += 1
        "Hello world (#{count[:hellos]})\n"
      when "/datetime"
        count[:total_requests] += 1
        Time.new.strftime('%m:%M%p on %A, %B %e, %Y')
      when "/shutdown"
        count[:total_requests] += 1
        tcp_server.close
        "Total Requests: #{count[:total_requests]}"
      else
        count[:total_requests] += 1
        "404 Bro"
      end
  end

end


server = Server.new
server.start
