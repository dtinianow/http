require './test/testhelper'
require './lib/server'


class ServerTest < Minitest::Test

  def test_server_exists
    skip
    server = Server.new
    assert_instance_of Server, server
  end

  def test_tcp_server_exists
    skip
    tcp_server = TCPServer.new(9000)
    assert_instance_of TCPServer, tcp_server
  end

  def test_can_keep_track_of_hello
    # server = Server.new

    # assert_equal 0, server.hello_count
    # server.response
    # assert_equal 1, server.hello_count
    # server.response
    # refute_equal 1, server.hello_count
    # assert_equal 2, server.hello_count
  end

  def test_get_request_returns_a_request
    f = Faraday.get('http://localhost:9292/')
    assert_equal "ruby", f.headers["server"]
  end

  def test_body
    f = Faraday.get('http://localhost:9292/hello')
    assert f.body.include?("Hello world")
  end

  def test_hello_stuff
    s = Server.new
    assert_equal 0, s.count[:hellos]
    s.return_path_hello
    assert_equal 1, s.count[:hellos]
  end


  # response.headers
  # response.body
  # response = Faraday.get 'http://localhost:9292/'


end
