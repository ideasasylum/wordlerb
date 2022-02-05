require "rainbow"

class Wordle::Game
  include Enumerable

  attr_reader :results, :dictionary

  def initialize word: nil, dictionary: nil
    @results = []
    @dictionary = dictionary || Wordle::Dictionary.new
    @correct_word = (word || @dictionary.sample).upcase
  end

  def guess word
    raise Wordle::WordNotFoundException unless dictionary.member?(word)
    raise Wordle::GameOverException if over?
    raise Wordle::GameWonException if won?

    word.upcase!
    letter_details = word.each_char.with_index.map do |letter, index|
      status = if @correct_word[index] == letter
        :correct
      elsif @correct_word.include? letter
        :wrong_position
      else
        :not_present
      end
      [letter, status]
    end

    result = Wordle::Result.new(letter_details)
    results << result
    result
  end

  def won?
    return false if results.empty?

    results.last.correct?
  end

  def over?
    results.size == 6
  end

  def each
    results.each { |result| yield result }
  end

  def print!
    each { |result| result.print! }
    nil
  end

  private

  def default_dictionary
    file_name = File.expand_path("words.txt", File.dirname(__FILE__))
    File.readlines(file_name).map { |line| line }
  end
end
