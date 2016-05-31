require './test/testhelper'
require './lib/server'
require './lib/parser'

class ParserTest < Minitest::Test

  def test_parser_exists
    parser = Parser.new(request)
    assert_instance_of Parser, parser
  end



end
