require './test/testhelper'
require './lib/server'
require './lib/parser'

class ParserTest < Minitest::Test

  attr_reader :request, :parser

  def setup
    @request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]
    @parser = Parser.new(request)
  end

  def test_parser_exists
    assert_instance_of Parser, parser
  end

  def test_can_split_first_request_line
    expected = "Verb: GET\nPath: /\nProtocol: HTTP/1.1"
    assert_equal expected, parser.first_request_line
  end

  def test_can_split_middle_request_lines
    expected = "Host: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1"
    assert_equal expected, parser.remaining_request_lines
  end

  def test_can_split_last_request_line
    expected = "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    assert_equal expected, parser.last_request_line
  end

  def test_can_combine_all_modified_request_lines
    expected = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    assert_equal expected, parser.all_request_lines
  end

  def test_can_get_verb
    assert_equal 'GET', parser.get_verb
  end

  def test_can_get_root_path
    assert_equal '/', parser.get_root
  end

  def test_can_get_protocol
    assert_equal 'HTTP/1.1', parser.get_protocol
  end

  def test_can_get_host
    assert_equal '127.0.0.1', parser.get_host
  end

  def test_can_get_port
    assert_equal '9292', parser.get_port
  end

  def test_can_get_origin
    assert_equal "127.0.0.1", parser.get_origin
  end

  def test_can_get_accept
    assert_equal 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8', parser.get_accept
  end

  def test_request_hash
    assert_equal "thing", parser.request_hash
  end

end
