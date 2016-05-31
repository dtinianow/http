require './test/testhelper'
require './lib/server'


class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new
    assert_instance_of Server, server
  end

  def test_get_request_returns_a_request
    f = Faraday.get('http://localhost:9292/')
    assert_equal "ruby", f.headers["server"]
  end

  def test_body_of_hello_path
    f = Faraday.get('http://localhost:9292/hello')
    assert f.body.include?("Hello world")
  end

  def test_hello_count_works
    s = Server.new
    assert_equal 0, s.count[:hellos]
    s.return_path_hello
    assert_equal 1, s.count[:hellos]
  end

  def test_datetime_path
    s = Server.new
    assert_equal Time.new.strftime('%m:%M%p on %A, %B %e, %Y'), s.return_path_datetime
    assert_equal 1, s.count[:total_requests]
  end

  def test_unknown_path
    s = Server.new
    assert_equal "404 Bro", s.return_path_unknown
    assert_equal 1, s.count[:total_requests]
  end

  def test_total_requests_between_pages
    s = Server.new
    assert_equal 0, s.count[:total_requests]
    s.return_path_unknown
    assert_equal 1, s.count[:total_requests]
    s.return_path_hello
    assert_equal 2, s.count[:total_requests]
    s.return_path_datetime
    assert_equal 3, s.count[:total_requests]
  end

  def test_root_path
    f = Faraday.get('http://localhost:9292/')
    assert f.body.include?("Verb:")
  end

  # def test_root_path
  #   skip
  #   s = Server.new(true)
  #   s.start
  #   s.return_path_root
  #   assert_equal 1, s.count[:total_requests]
  # end
end
