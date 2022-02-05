require "wordle/version"
require "wordle/result"
require "wordle/dictionary"
require "wordle/game"
require "wordle/player"

module Wordle
  class WordNotFoundException < StandardError
  end

  class GameOverException < StandardError
  end
end
