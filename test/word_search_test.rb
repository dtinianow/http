require './test/testhelper'
require './lib/word_search'

class WordSearchTest < Minitest::Test

  def test_word_finder_contains_words_from_dictionary
    assert_equal "A", WordSearch.new.words.first
    assert_equal "Zyzzogeton", WordSearch.new.words.last
  end

  def test_check_if_word_is_in_dictionary
    word_search = WordSearch.new
    assert_equal "HELLO is a known word", word_search.check_dictionary("hElLo")
    assert_equal "FLSDK is not a known word", word_search.check_dictionary("fLsDk")
  end

end
