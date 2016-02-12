module Victoria
  class GameOver < StandardError
  end

  class User < DataBase
    attr_accessor :name
    attr_reader :word, :score

    def [](letter)
      raise GameOver if(@word.failed?)
       @word[letter.downcase] unless(@word.guessed?)
      if(@word.guessed? and not(@word_scored))
        @score = @score + 1
        @word_scored = true
        @word
      end

      if(@word.failed?)
        save_highscore
        @failed = true
        raise GameOver, "Game Over: score: #@score, user: #@name"
      end
      self.word.revealed
    end

    def failed?
      @failed
    end

    def new_word
      @word_scored = false
      @word = Word.new
    end

    def save_highscore
      if(has_record?('HIGHSCORES', "#{@name}", 'PLAYER'))
        old = selector('SCORE', 'HIGHSCORES', "PLAYER='#{@name}'")[0][0]
        updater('HIGHSCORES',
                "PLAYER='#{@name}', SCORE=#{@score}",
                "PLAYER='#{@name}'") if(old < @score)
      else
        inserter('HIGHSCORES', "'#{@name}', #@score", "PLAYER, SCORE")
      end
    end

    def initialize
      @word = Word.new
      @score = 0
      @failed = false
      @word_scored = false
    end
  end
end
