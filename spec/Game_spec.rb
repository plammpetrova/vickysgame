require "sqlite3"
require_relative "../source/DataBase.rb"
require_relative "../source/Word.rb"
require_relative "../source/User.rb"
require_relative "../source/Game.rb"

describe "Victoria::Game" do
  before :each do
    ('A'..'K').each.with_index do |letter, index|
      query = "INSERT INTO HIGHSCORES VALUES ('#{letter * 3}', #{index});"
      SQLite3::Database.new("./victoria.db").execute(query)
    end
    SQLite3::Database.new("./victoria.db")
                     .execute("INSERT INTO DICTIONARY VALUES ('victoria')")
    @game = Victoria::Game.new
  end

  after :each do
    SQLite3::Database.new("./victoria.db")
                     .execute("DELETE FROM HIGHSCORES;")
    SQLite3::Database.new("./victoria.db")
                     .execute("DELETE FROM DICTIONARY;")
  end

  describe "#highscores" do
    it "displays the first 10 best scores" do
      expect(@game.highscores.length).to eq 10
    end
  end

  describe "#in_database?" do
    it "returns true if the word exists in the database" do
      expect(@game.in_database?("victoria")).to eq true
    end
    it "returns false if the word does not exist in the database" do
      expect(@game.in_database?("plamena")).to eq false
    end
  end
end
