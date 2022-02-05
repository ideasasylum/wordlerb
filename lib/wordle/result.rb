class Wordle::Result
  include Enumerable

  attr_reader :letters

  def initialize details
    @letters = details
  end

  def each
    letters.each { |letter, status| yield letter, status }
  end

  def correct?
    all? { |letter, status| status == :correct }
  end

  def print!
    each do |letter, status|
      color = case status
      when :correct then :darkgreen
      when :wrong_position then :yellow
      else :darkgray
      end

      print Rainbow(letter).fg(:black).bg(color)
    end
    puts
  end
end
