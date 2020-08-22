require 'yaml'
require './lib/interface'
require './lib/game'
require './lib/dictionary'

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