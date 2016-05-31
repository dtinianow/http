require_relative 'parser'
require 'socket'
require 'pry'

class Server

attr_reader :tcp_server, :count

  def initialize(start = false)
    @tcp_server    = TCPServer.new(9292) if start
    @count         = {hellos: 0, total_requests: 0}
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
    output = check_path
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    client.close
  end

  def root_output
    @parsed_message.request.join("\r\n")
  end

  def check_path
    case @parsed_message.path.downcase
      when "/"
        return_path_root
      when "/hello"
        return_path_hello
      when "/datetime"
        return_path_datetime
      when "/shutdown"
        return_path_shutdown
      else
        return_path_unknown
      end
  end

  def return_path_root
    count[:total_requests] += 1
    "<pre>\n#{@parsed_message.all_request_lines}\n</pre>"
  end

  def return_path_hello
    count[:hellos] += 1
    count[:total_requests] += 1
    "Hello world (#{count[:hellos]})\n"
  end

  def return_path_datetime
    count[:total_requests] += 1
    Time.new.strftime('%m:%M%p on %A, %B %e, %Y')
  end

  def return_path_shutdown
    count[:total_requests] += 1
    tcp_server.close
    "Total Requests: #{count[:total_requests]}"
  end

  def return_path_unknown
    count[:total_requests] += 1
    "404 Bro"
  end

end

if __FILE__ == $0
  server = Server.new(true)
  server.start
end
