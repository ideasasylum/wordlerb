require "rainbow"

class Wordle::Dictionary
  include Enumerable

  attr_reader :words

  def initialize words = default_words
    @words = words
  end

  def each
    words.each { |word| yield word }
  end

  def size
    words.size
  end

  def sample
    words.sample
  end

  private

  def default_words
    file_name = File.expand_path("words.txt", File.dirname(__FILE__))
    File.readlines(file_name).map { |line| line.strip }
  end
end
