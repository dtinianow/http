require './test/testhelper'
require './lib/server'
require './lib/parser'

class ParserTest < Minitest::Test
  # def request
  #
  # end
  #
  # def setup
  #   @parser = Parser.new
  # end
  #
  # def test_it_defined_verb
  #   assert_equal "GET", @parser.verb
  # end

  def test_parser_exists
    request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Connection: keep-alive",
               "Cache-Control: no-cache",
               "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
               "Postman-Token: 3c37014c-ab5c-20d6-1a7c-ddcd5c01339c",
               "Accept: */*",
               "Accept-Encoding: gzip, deflate, sdch",
               "Accept-Language: en-US,en;q=0.8"]
    parser = Parser.new(request)
    assert_instance_of Parser, parser
  end

  def test_can_split_first_request_line
    request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Connection: keep-alive",
               "Cache-Control: no-cache",
               "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
               "Postman-Token: 3c37014c-ab5c-20d6-1a7c-ddcd5c01339c",
               "Accept: */*",
               "Accept-Encoding: gzip, deflate, sdch",
               "Accept-Language: en-US,en;q=0.8"]
    parser = Parser.new(request)
    expected = "Verb: GET\nPath: /\nProtocol: HTTP/1.1"
    assert_equal expected, parser.first_request_line
  end

  def test_can_split_middle_request_lines
    request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Connection: keep-alive",
               "Cache-Control: no-cache",
               "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
               "Postman-Token: 3c37014c-ab5c-20d6-1a7c-ddcd5c01339c",
               "Accept: */*",
               "Accept-Encoding: gzip, deflate, sdch",
               "Accept-Language: en-US,en;q=0.8"]
    parser = Parser.new(request)
    expected = "Host: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1"
    assert_equal expected, parser.remaining_request_lines
  end

  def test_can_split_last_request_line
    request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
               "Connection: keep-alive",
               "Cache-Control: no-cache",
               "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
               "Postman-Token: 3c37014c-ab5c-20d6-1a7c-ddcd5c01339c",
               "Accept: */*",
               "Accept-Encoding: gzip, deflate, sdch",
               "Accept-Language: en-US,en;q=0.8"]
    parser = Parser.new(request)
    expected = "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    assert_equal expected, parser.last_request_line
  end

  def test_can_combine_all_modified_request_lines
    request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]
    parser = Parser.new(request)
    expected = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    assert_equal expected, parser.all_request_lines
  end

end
