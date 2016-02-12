module Victoria
  class Added < StandardError
  end

  class Game < DataBase
    attr_accessor :user

    def in_database?(word)
      has_record?('DICTIONARY', word, 'WORD')
    end

    def highscores
      result = selector('SCORE ,PLAYER',
                        'HIGHSCORES',
                        nil,
                        'SCORE DESC')
      result[0...10]
    end
	
    def initialize
      @user = User.new
    end
  end
end
