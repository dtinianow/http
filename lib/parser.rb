class Parser

#Parse first request line into three parts
#Check the second element and create conditionals

# Create total_request counter and increment by one for each live request

# If /, do nothing (ie return get_request method)
# If /hello, increase hello_count by one
# If /datetime, post datetime in format
# If /shutdown, post Total Requests: #{total_requests} and shutdown server
  # tcp_server.close

  attr_reader :request, :first_request_line

  def initialize(request)
    @request = request
  end

  def first_request_line
    first_line = request[0].split(" ")
    "Verb: #{first_line[0]}\nPath: #{first_line[1]}\nProtocol: #{first_line[2]}"
  end

  def remaining_request_lines
    second_line = request[1].delete(" ").split(":")
    "Host: #{second_line[1]}\nPort: #{second_line[2]}\nOrigin: #{second_line[1]}"
  end

  def last_request_line
    last_line = request[2].split(" ")
    "Accept: #{last_line[1]}"
  end

end
