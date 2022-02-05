class Wordle::Player
  attr_reader :game

  def initialize game: nil
    @game ||= Wordle::Game.new
  end

  def play
    loop do
      step
      break if game.won? || game.over?
    end
  end

  def step
    word = possible_words.sample
    puts "Guessing… #{word}"
    game.guess word
    game.print!
    puts "------"
  end

  def possible_words
    regex = matcher
    # puts "Finding words using #{regex}"
    game.dictionary.select do |word|
      word =~ regex
    end
  end

  def matcher
    regex = /\A[#{characters(0).join}][#{characters(1).join}][#{characters(2).join}][#{characters(3).join}][#{characters(4).join}]\z/
  end

  def characters position = nil
    chars = ("a".."z").to_a - excluded_characters

    if position
      # puts "Checking position #{position} on all results"
      game.results.each do |result|
        letter, status = result.letters[position]
        # puts "#{letter}, #{status}"
        case status
        when :wrong_position
          # puts "position #{position} cannot be #{letter.downcase}"
          chars.delete letter.downcase
        when :correct
          # puts "position #{position} can only be #{letter.downcase}"
          chars = [letter.downcase]
          break
        end
      end
      # puts "position #{position} characters are #{chars}"
    end

    chars
  end

  def excluded_characters
    game.results.map do |result|
      result.map { |letter, status| letter.downcase if status == :not_present }
    end.flatten.uniq.compact
  end
end
