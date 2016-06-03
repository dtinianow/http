
class Parser

  attr_reader :request, :request_info, :all_request_lines, :path

  def initialize(request)
    @request         = request
    @path            = request[0].split(" ")[1].split('?')[0]
  end

  def word
    if request[0].split(" ")[1].split('?')[1].split('=')[0] == 'word'
      word = request[0].split(" ")[1].split('?')[1].split('=')[1]
    end
    word
  end

  def verb_is_post?
    request_info["Verb:"] == 'POST'
  end

  def request_info
    {   "Verb:" => get_verb,
        "Path:" => get_root,
        "Protocol:" => get_protocol,
        "Host:" => get_host,
        "Port:" => get_port,
        "Origin:" => get_origin,
        "Accept:" => get_accept,
        "Content Length:" => get_content_length}
  end

  def get_verb
    request[0].split(" ")[0]
  end

  def get_root
    request[0].split(" ")[1]
  end

  def get_protocol
    request[0].split(" ")[2]
  end

  def get_host
    request[1].delete(" ").split(":")[1]
  end

  def get_port
    request[1].delete(" ").split(":")[2]
  end

  def get_origin
    request[1].delete(" ").split(":")[1]
  end

  def get_accept
    request[2].split(" ")[1]
  end

  def get_content_length
    request[3].split(" ")[1]
  end

  def all_request_lines
    request_info.map do |key, value|
      "#{key} #{value}"
    end.join("\n")
  end

end
