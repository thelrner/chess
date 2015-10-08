class HumanPlayer
  attr_reader :color

  def initialize(color, board)
    @color = color
  end

  def get_move
    begin
    puts "Where do you move? ie. f2, f4"
    move = gets.chomp
    validate_input(move)

    rescue InputError => e
      puts "#{e.message}"
      retry
    end

    move = move.split(',').map(&:strip)
    move.map {|coord| convert_to_position(coord)}
  end

  def validate_input(input)
    match_data = input.match(/\A[a-h][1-8], ?[a-h][1-8]\z/)
    raise InputError.new("Invalid input") if match_data.nil?
  end

  def convert_to_position(letter_num)
    letter_hash = Hash[("a".."h").to_a.zip((0..7).to_a)]
    [ (7-letter_num[1].to_i + 1), letter_hash[letter_num[0]] ]
  end

end
