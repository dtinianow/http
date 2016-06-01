require './test/testhelper'
require './lib/server'
require './lib/response_generator'

class ResponseGeneratorTest < Minitest::Test

  def test_hello_count_works
    s = Server.new
    r = ResponseGenerator.new
    assert_equal 0, s.count[:hellos]
    r.return_path_hello(s.count)
    assert_equal 1, s.count[:hellos]
  end

  def test_datetime_path
    s = Server.new
    r = ResponseGenerator.new
    assert_equal Time.new.strftime('%m:%M%p on %A, %B %e, %Y'), r.return_path_datetime(s.count)
    assert_equal 1, s.count[:total_requests]
  end

  def test_unknown_path
    s = Server.new
    r = ResponseGenerator.new
    assert_equal "404 Bro", r.return_path_unknown(s.count)
    assert_equal 1, s.count[:total_requests]
  end

  def test_total_requests_between_pages
    s = Server.new
    r = ResponseGenerator.new
    assert_equal 0, s.count[:total_requests]
    r.return_path_unknown(s.count)
    assert_equal 1, s.count[:total_requests]
    r.return_path_hello(s.count)
    assert_equal 2, s.count[:total_requests]
    r.return_path_datetime(s.count)
    assert_equal 3, s.count[:total_requests]
  end




end
