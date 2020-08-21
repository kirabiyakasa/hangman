require 'yaml'
class Interface
  def initialize()
    @board = []
  end

  def show_rules()
  end

  def display_new_game()
    puts "1) New Game   2) Load Game"
  end

  def display_turn_number(game)
    puts "\nGuesses Left: #{game.guesses_left}"
  end

  def display_controls()
    puts "\n\n              1) Save Game"
    puts "\nEnter a letter to guess."
  end

  def update_board(game)
    updated_board = []
    game.correct_guesses.values.each_with_index do |letter, index|
      if letter.empty?
        updated_board << "_ "
      else
        updated_board << letter + " "
      end
    end
    updated_board = "\n\n" + updated_board.join[0..-2]
  end

  def show_board(game, wrong_guesses)
    updated_board = update_board(game)
    @board = updated_board
    if game.guesses_left == 6
      puts @board
      puts "\nWrong letters: #{wrong_guesses.join(",")}"
    elsif game.correct_guess_count == 0 || game.guess.length > 1
      puts @board
      puts "\n\nWrong guess.\n\n"
      puts "\nWrong letters: #{wrong_guesses.join(",")}"
    else
      puts @board
      puts "\n\nGuessed correctly."
      puts "#{game.guess} appears #{game.correct_guess_count} time(s)."
      puts "Wrong letters: #{wrong_guesses.join(",")}"
    end
  end
end

class Dictionary

  def get_random_word()
    filtered_dictionary = []
    filter_dictionary(filtered_dictionary)
    random_word = filtered_dictionary[rand(0..(filtered_dictionary.length - 1))]
  end
  
  private
  def filter_dictionary(filtered_dictionary)
    File.open('5desk.txt', 'r').each_line do |line|
      line = line.chomp
      if line.length > 4 && line.length < 12
        filtered_dictionary << line
      end
    end
  end

end

class Game
  attr_reader :correct_guesses, :wrong_guesses, :guesses_left, :guess,
    :correct_guess_count

  def initialize()
    @chosen_word = ""
    @correct_guesses = {}
    @wrong_guesses = []
    @guesses_left = 6
    @guess = ""
    @correct_guess_count = 0
  end

  def choose_word(dictionary)
    @chosen_word = dictionary.get_random_word
    set_blank_spaces()
  end

  def get_input()
    user_input = gets.chomp.downcase
    until (("a".."z").include?(user_input) || user_input == "1" ||
      user_input.length == @chosen_word.length)
      puts "Please enter a letter or guess the" +
        " #{@chosen_word.length} letter word."

      user_input = gets.chomp.downcase
    end

    while (@correct_guesses.values.include?(user_input) ||
      @wrong_guesses.include?(user_input))
      puts "You have already guessed #{user_input}."
      puts "Try a new letter."
      user_input = gets.chomp.downcase
    end
    return user_input
  end

  def make_guess(guess, interface)
    chosen_word = @chosen_word.split("")
    @guess = guess
    @correct_guess_count = 0
    if guess.length == 1
      chosen_word.each_with_index do |letter, index|
        if letter == guess
          @correct_guesses[index] = guess
          @correct_guess_count += 1
        end
      end

      if @chosen_word.include?(guess) == false
        @wrong_guesses << guess
      end
    else
      guess_word()
    end
  end

  def new_turn(game, interface)
    if @correct_guess_count == 0
      @guesses_left -= 1
    end
    play_game(game, interface)
  end

  def check_win_loss_conditions(game, interface)
    if @correct_guesses.values.none?("")
      puts "\nComputer's word: #{@chosen_word}"
      puts "\n\nPlayer Wins!"
      start_game()
    elsif @guesses_left == 1
      interface.show_board(game, game.wrong_guesses)
      puts "Out of guesses!"
      puts "\nComputer's word was #{@chosen_word}."
      puts "\n\nComputer Wins!"
      start_game()
    end
  end

  private
  def guess_word()
    if @guess == @chosen_word
      puts "\nComputer's Word: #{@chosen_word}"
      puts "\nGuessed Correctly!"
      puts "\nPlayer wins!"
      start_game()
    end
  end

  def set_blank_spaces()
    @chosen_word.split("").each_with_index do |letter, index|
      @correct_guesses[index] = ""
    end
  end

end

def play_game(game, interface)
  interface.show_board(game, game.wrong_guesses)
  interface.display_turn_number(game)
  interface.display_controls
  user_input = game.get_input()
  if user_input == "1"
    save_game(game)
  else
    game.make_guess(user_input, interface)
  end
  game.check_win_loss_conditions(game, interface)
  game.new_turn(game, interface)
end

def save_game(game)
  saved_game = YAML.dump(game)
  save_file = "save_file.yml"

  File.open(save_file, 'w') do |file|
    file.write saved_game
  end
  start_game()
end

def load_game(interface)
  game = YAML.load(File.read("save_file.yml"))
  play_game(game, interface)
end

def new_game(interface)
  dictionary = Dictionary.new
  game = Game.new
  game.choose_word(dictionary)
  play_game(game, interface)
end

def start_game()
  interface = Interface.new
  interface.show_rules
  interface.display_new_game
  answer = gets.chomp
  until answer == "1" || answer == "2"
    puts "Please enter a valid input."
    answer = gets.chomp
  end
  if answer == "1"
    new_game(interface)
  elsif answer == "2"
    begin
      load_game(interface)
    rescue
      puts "\nNo save file to load."
      start_game()
    end
  end
end
start_game()