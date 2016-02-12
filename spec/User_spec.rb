require "sqlite3"
require_relative "../source/DataBase.rb"
require_relative "../source/Word.rb"
require_relative "../source/User.rb"

describe Victoria::User do
  before :each do
    SQLite3::Database.new("./victoria.db").execute("INSERT INTO DICTIONARY VALUES ('victoria')")
    @user = Victoria::User.new
    @user.name = "little guest"
  end

  after :each do
    SQLite3::Database.new("./victoria.db").execute("DELETE FROM HIGHSCORES;")
    SQLite3::Database.new("./victoria.db").execute("DELETE FROM DICTIONARY;")
  end

  describe "#failed?" do
    it "shows corectly if user has failed or not" do
      expect(@user.failed?).to eq false
    end
  end

  describe "#word" do
    it "returns the word given to the user" do
      expect(@user.word.revealed).to eq ['_', '_', '_', '_', '_', '_', '_', '_']
    end
  end

  describe "#[]" do
    it "can insert letter by '[]' method" do
      @user["v"]
      expect(@user.word.revealed).to eq ['v', '_', '_', '_', '_', '_', '_', '_']
    end
  end

  describe "#score" do
    it "returns corectly the score of the user" do
      expect(@user.score).to eq 0
    end
  end

  describe "#save_highscore" do
    it "saves corectly highscore for new user" do
      SQLite3::Database.new("./victoria.db").execute("DELETE FROM HIGHSCORES;")
      @user.save_highscore
      expect(SQLite3::Database.new("./victoria.db").execute("SELECT * FROM HIGHSCORES")).not_to eq []
    end
    it "saves corectly highscore for user" do
      @user.save_highscore
      @user.instance_variable_set(:@score, 4)
      @user.save_highscore
      expect(SQLite3::Database.new("./victoria.db").execute("SELECT * FROM HIGHSCORES WHERE player='little guest' AND score=4")).not_to eq []
    end
  end
end
