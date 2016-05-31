
class Parser

  attr_reader :request, :all_request_lines, :path


  def initialize(request)
    @request       = request
    @path          = request[0].split(" ")[1].split('?')[0]
  end

  #if request[0].split(" ")[1].include?('?')
  # @path = path?param=value
  def word
    if request[0].split(" ")[1].split('?')[1].split('=')[0] == 'word'
      word = request[0].split(" ")[1].split('?')[1].split('=')[1]
    end
    word  #redirect if word not there. #rubular
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

  def all_request_lines
    "#{first_request_line}\n#{remaining_request_lines}\n#{last_request_line}"
  end

end
