require './test/testhelper'
require './lib/server'


class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new
    assert_instance_of Server, server
  end

  def test_root_path
    f = Faraday.get('http://localhost:9292/')
    assert f.body.include?("Verb:")
  end

  def test_get_request_returns_a_request
    f = Faraday.get('http://localhost:9292/')
    assert_equal "ruby", f.headers["server"]
    assert_equal f["content-type"], "text/html; charset=iso-8859-1"
  end

  def test_body_of_hello_path
    f = Faraday.get('http://localhost:9292/hello')
    assert f.body.include?("Hello world")
  end

  def test_body_of_start_game
    f = Faraday.post('http://localhost:9292/start_game')
    assert f.body.kind_of?(String)
  end

  def test_body_of_game
    Faraday.post('http://localhost:9292/start_game')
    f = Faraday.get('http://localhost:9292/game')
    assert f.body.include?("Your guess count is")
  end
end
