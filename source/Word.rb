module Victoria
  class Word < DataBase
    attr_reader :revealed, :wrong, :used

    def [](letter)
      if not @used.include?(letter)
        @used << letter.upcase
      end
      if @revealed.include?(letter)
        @wrong = @wrong + 1
      end
      has_letter?(letter) ? reveal(letter) : @wrong = @wrong + 1
      @revealed
    end

    def guessed?
      @wrong < 10 and @hidden[1..-1].join("") == @revealed[1..-1].join("")
    end

    def failed?
      @wrong >= 10
    end

    def has_letter?(letter)
      @hidden & [letter] == [letter]
    end

    def word
      @word
    end

    def initialize
      @hidden = selector('word',
                         'dictionary',
                         nil,
                         "RANDOM() LIMIT 1")[0][0].chars
      @revealed = @hidden.map { |letter| letter = "_" }
      @wrong = 0
      @used = []
	  @word = @hidden.join("")
	  has_letter?(@word[0])
    end

    def reveal(letter)
      @hidden.each.with_index do |secret_letter, index|
        if(letter == secret_letter)
          @revealed[index] = letter
        end
      end
      @revealed
    end
  end
end
