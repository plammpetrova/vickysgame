require "sqlite3"
require_relative "../source/DataBase.rb"
require_relative "../source/Word.rb"

describe Victoria::Word do
  before :each do
    query = "INSERT INTO DICTIONARY VALUES ('victoria')"
    SQLite3::Database.new("./victoria.db").execute(query)
    @word = Victoria::Word.new
  end

  after :each do
    query = "DELETE FROM DICTIONARY"
    SQLite3::Database.new("./victoria.db").execute(query)
  end

  describe "#guessed?" do
    it "returns false if the word is not guessed" do
      expect(@word.guessed?).to eq false
    end

    it "returns true when all of the letters are revealed" do
      word = ['v','i','c','t','o','r','i','a']
      word.each do |letter|
        @word[letter]
      end
      expect(@word.revealed).to eq word
    end
  end

  describe "#failed?" do
    it "returns false if the word has not failed" do
      expect(@word.failed?).to eq false
    end

    it "returns true when 10 times wrong letter is entered" do
      (1..10).each { |_| @word['z'] }
      expect(@word.failed?).to eq true
    end

  end

  describe "#revealed" do
    it "has correct list of underlines for a given word from the DB" do
      expect(@word.revealed.length).to eq 8
    end
  end

  describe "#[]" do
    it "has correctly defined '[]' method for letter guessing" do
      @word['i']
      expect(@word.revealed).to eq ['_', 'i', '_', '_', '_', '_', 'i', '_']
    end
  end

  describe "#used" do
    it "saves used letters in an array correctly" do
      @word['a']
      @word['z']
      expect(@word.used).to eq ['A', 'Z']
    end
  end
end
