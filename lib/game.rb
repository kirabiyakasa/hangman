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

  def filter_invalid_guesses(user_input)
    if (("a".."z").include?(user_input) || user_input == "1" ||
      user_input.length == @chosen_word.length)
      return true
    else
      puts "Please enter a letter or guess the" +
      " #{@chosen_word.length} letter word."
      return false
    end
  end

  def filter_previous_guesses(user_input)
    if (@correct_guesses.values.include?(user_input) ||
      @wrong_guesses.include?(user_input))
      puts "You have already guessed #{user_input}."
      puts "Try a new letter."
      return false
    else 
      return true
    end
  end

  def get_input()
    user_input = gets.chomp.downcase
    until (filter_invalid_guesses(user_input) == true &&
      filter_previous_guesses(user_input) == true)

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