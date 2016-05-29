require './test/testhelper'
require './lib/server'


class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new
    assert_instance_of Server, server
  end

  def test_tcp_server_exists
    tcp_server = TCPServer.new(9000)
    assert_instance_of TCPServer, tcp_server
  end

  def test_can_keep_track_of_hello
    server = Server.new

    assert_equal 0, server.hello_count
    # server.response
    # assert_equal 1, server.hello_count
    # server.response
    # refute_equal 1, server.hello_count
    # assert_equal 2, server.hello_count
  end


end
