class Interface
  def initialize()
    @board = []
  end

  def show_rules()
    puts "Hangman Rules:" +
    "\n--------------" +
    "\nPress the corresponding keys to begin a new game or load a previous " +
    "game." +
    "\nComputer will pick a word from a dictionary." +
    "\nPress a letter key followed by the \"Enter\" key to make a guess." +
    "\nYou can make 6 wrong guesses. A correct guess will not consume a " +
    "guess." +
    "\nIf you run out of guesses the computer wins." +
    "\nYou can try guessing the entire word at any time." +
    "\nAlso, you save at any point during the game and resume later by " +
    "\npressing the corresponing key followed by the \"Enter\" key." +
    "\n--------------"
  end

  def display_new_game()
    puts "\n\n1) New Game   2) Load Game"
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