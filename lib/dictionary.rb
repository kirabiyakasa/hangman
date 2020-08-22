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