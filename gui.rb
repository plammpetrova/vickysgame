require "sqlite3"
require "./source/DataBase.rb"
require "./source/Word.rb"
require "./source/User.rb"
require "./source/Game.rb"

class Actions
  @@game = Victoria::Game.new
  def initialize(app)
    @app = app
  end
	
	def login(username)
	  @app.app do
	    @@game.user.name = username
	    alert "Здравей, #{username}!"
	  end
  end
	
 def new_game
	@app.app do
    clear
    background "./images/background.jpg"
		
    word_view = @@game.user.word.revealed[1..-1].map do |letter|
      letter = "#{letter} "
    end.reduce(&:+)

    title("#{@@game.user.word.word[0]} #{word_view}", align: 'center', top: 380)

    stack(top:90, left: 280) do
      used = @@game.user.word.used.to_s.gsub("[", "").gsub("]", "").gsub("\"", "")
      para strong("Днес с нас играе: #{@@game.user.name}")
      para strong("Правилно познати думички: #{@@game.user.score}")
      para strong("Грешки: #{@@game.user.word.wrong}")
      para strong("Буквички, които са използвани:\n #{used}", left: 10, top: 10)
    end
		
		image "./images/#{@@game.user.word.word}.png", top: 80, left: 30

    stack(top:260, left: 270) do
      letter = edit_line
		  
		  inscription " "

      button "има ли ...?" do
        if(@@game.user.word.failed?)
          clear
          @@game.user.save_highscore
          background "#FFF"
          background "./images/background.jpg"
          title "Край на играта", align: 'center', top: 130

          stack(top:440) do
            style(:margin_left => '65%', :left => '-25%')
            button "Изход" do
              exit
            end
          end
        end

        @@game.user[letter.text]

        if(@@game.user.word.guessed?)
          the_word = @@game.user.word.revealed.reduce(&:+)
          alert "Браво на теб, умно дете! Ти позна думичката #{@@game.user.word.word[0]}#{the_word[1..-1]}"
          @@game.user.new_word
        end

        @actions.new_game
      end
    end
		
		stack(top:470) do
      style(:margin_left => '52.5%', :left => '-25%')
		  button "Назад към менюто" do
        @actions.menu
      end
		end

		stack(top:510) do
		  style(:margin_left => '65%', :left => '-25%')
      button "Изход" do
		    @@game.user.save_highscore
        exit
      end
    end
  end
end
	
	def highscores
      @app.app do
        clear
        background "#FFF"
        background "./images/background.jpg"

        stack(margin: 30) do
           title "Най-добри резултати в Играта на Вики", align: 'center', top: 10, underline: 'single'

          output = "\n\n\n"
          @@game.highscores.each.with_index do |row, index|
            output = output + (index + 1).to_s + ". " +
                     row[1] + ' - ' + row[0].to_s + "" + "\n"
          end
          para(strong(output), align: 'center', top: 90)
        end

        stack(top:440) do
          style(:margin_left => '52.5%', :left => '-25%')
		  button "Назад към менюто" do
            @actions.menu
          end
		end
		stack(top:480) do
		  style(:margin_left => '65%', :left => '-25%')
          button "Изход" do
            exit
          end
        end
		
		para strong("Днес с нас играе: #{@@game.user.name}"), align: 'center'
      end
    end
	
	def menu
      @app.app do
        clear
        background "./images/background.jpg"


        title("Играта на Вики", align: 'center', top: 10, underline: 'single')
        

        stack(top:160) do
		  style(:margin_left => '62.5%', :left => '-25%')
          button "Нова игра" do
            @actions.new_game
          end
		end
		
		stack(top:200) do
		  style(:margin_left => '50%', :left => '-25%')
          button "Най-добри резултати" do
            @actions.highscores
          end
		 end

        stack(top:240) do
		  style(:margin_left => '62.5%', :left => '-25%')
          button "За играта" do
            alert "Игра, направена за малката ми сестричка Вики и\n   курса по \"Програмиране с Руби\" 2015/2016.\n \t\t\t\t\t\  Плам Петрова"
          end
		end
        
		stack(top:280) do
		  style(:margin_left => '70%', :left => '-25%')
          button "Exit" do
            exit
          end
        end
      end
    end
  end

Shoes.app(title: "Viki's Game", height: 550, resizable: false) do
  
  background "./images/background.jpg"
  image "./images/viki.png", top: 180, left: 280
  
  stack do
     title("Играта на Вики", align: 'center', top: 10, underline: 'single')
  end
  
  stack(top:300, left: 50) do
    @actions = Actions.new(self)
	inscription "ИМЕ"
	username = edit_line
	inscription " "
	button "Влез" do
	  if(username.text != "")
          @actions.login(username.text)
        else
          @actions.login("little guest")
        end
		@actions.menu
	end
  end
end

