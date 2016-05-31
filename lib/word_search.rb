class WordSearch

  def words
    File.read('/usr/share/dict/words').split("\n")
  end

  def check_dictionary(word)
    if words.include?(word.downcase) || words.include?(word.capitalize)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end

  end

end
