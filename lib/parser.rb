
class Parser

  attr_reader :request, :request_info, :all_request_lines, :path

  def initialize(request)
    @request         = request
    @path            = request[0].split(" ")[1].split('?')[0]
    @request_info    = {}
    @initialize_info = initialize_info
  end

  def word
    if request[0].split(" ")[1].split('?')[1].split('=')[0] == 'word'
      word = request[0].split(" ")[1].split('?')[1].split('=')[1]
    end
    word  #redirect if word not there. #rubular
  end

  def initialize_info
    get_verb
    get_root
    get_protocol
    get_host
    get_port
    get_origin
    get_accept
  end

  def get_verb
    request_info["Verb:"] = request[0].split(" ")[0]
  end

  def get_root
    request_info["Path:"] = request[0].split(" ")[1]
  end

  def get_protocol
    request_info["Protocol:"] = request[0].split(" ")[2]
  end

  def get_host
    request_info["Host:"] = request[1].delete(" ").split(":")[1]
  end

  def get_port
    request_info["Port:"] = request[1].delete(" ").split(":")[2]
  end

  def get_origin
    request_info["Origin:"] = request[1].delete(" ").split(":")[1]
  end

  def get_accept
    request_info["Accept:"] = request[2].split(" ")[1]
  end

  # def first_request_line
  #   first_line = request[0].split(" ")
  #   "Verb: #{first_line[0]}\nPath: #{first_line[1]}\nProtocol: #{first_line[2]}"
  # end
  #
  # def remaining_request_lines
  #   second_line = request[1].delete(" ").split(":")
  #   "Host: #{second_line[1]}\nPort: #{second_line[2]}\nOrigin: #{second_line[1]}"
  # end
  #
  # def last_request_line
  #   last_line = request[2].split(" ")
  #   "Accept: #{last_line[1]}"
  # end

  def all_request_lines
    request_info.map do |key, value|
      "#{key} #{value}"
    end.join("\n")
    # "#{first_request_line}\n#{remaining_request_lines}\n#{last_request_line}"
  end

end
