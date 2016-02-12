require "sqlite3"
require "./source/DataBase.rb"
require "./source/Word.rb"
require "./source/User.rb"
require "./source/Game.rb"
require "./source/Тextart.rb"


module Victoria
  class CLI
    def initialize(game = Game.new)
      @game = game
      @user = game.user
      login
    end

    def login
      system "clear"
      puts "What is your name?".center(80)
      username = gets.chomp
      username == "" ? @user.name = "little guest" : @user.name = username
      menu
    end

    def about_the_game
      puts "A simple game dedicated to my little sister Victoria".center(80)
      puts "and created for my Ruby course in FMI, Sofia University.".center(80)
      puts "~Plam Petrova~".center(80)
      puts "~1~ Back to the menu".center(80)
      puts "~2~ Quit".center(80)

      case gets.chomp
      when '1' then menu
      when '2' then quit_game
      end
    end

    def menu
      system "clear"
      puts "Hello, #{@user.name}!".center(80)
      puts "Menu".center(80)
      puts "~1~""New Game".center(80)
      puts "~2~ Best Scores".center(80)
      puts "~3~ About the game".center(80)
      puts "~4~ Quit".center(80)
      case gets.chomp
      when '1' then new_game
      when '2' then highscores
      when '3' then about_the_game
      when '4' then quit_game
      else menu
      end
    end

    def quit_game
      system "clear"
      exit
    end

    def highscores
      system "clear"
      result = []
        @game.highscores.each.with_index do |row, index|
        line = (index + 1).to_s + ". " + row[1] + " ~ "+ row[0].to_s
        result << line.center(80)
      end
      puts "Best Scores:".center(80)
      puts result.join
      puts "~1~ Back to the menu".center(80)
      puts "~2~ Quit".center(80)

      case gets.chomp
      when '1' then menu
      when '2' then quit_game
      else highscores
      end
    end

    def new_game
      loop do
        system "clear"
        wrong = "Wrong: #{@user.word.wrong}"
        if(@user.word.used != [])
          used = "Used letters: <<#{@user.word.used}>>"
        else
          used = "Used letters: << .... >>"
        end
        puts figure(@user.word.word.downcase)
        puts wrong.center(80)
        puts used.center(80)
        puts "Score: #{@user.score}".center(80)
        half_revealed = @user.word.word[0] + " " + @user.word.revealed[1..-1].inspect.gsub("[", "").gsub("]", "").gsub("\"", "").gsub(",", "")
        puts half_revealed.center(80)
        begin
          insert_letter
          @user.new_word if(@user.word.guessed?)
        rescue GameOver => ex
          system "clear"
          figure(@user.word.word.downcase)
          puts ex.message.center(80)
          break
        end
      end
      exit
    end


    def insert_letter
      puts "letter:".center(80)
      get = STDIN.first.chomp
      if(/^[a-zA-Z]$/.match get)
        @user[get.downcase]
      elsif(get == '!')
        @user.save_highscore
        exit
      else
        insert_letter
      end
    end
  end
end

Victoria::CLI.new
