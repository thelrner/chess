class HumanPlayer

  attr_reader :color

  def initialize(color, board)
    @color = color
  end

  def get_move
    begin
    puts "Where do you move? ie. f2, f5"
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
    match_data = input.match(/\A[a-h][1-8], ?[a-h][1-8]\z/)     # http://rubular.com/
    raise InputError.new("Invalid input") if match_data.nil?
  end

  def convert_to_position(letter_num)
    letter_hash = Hash[("a".."h").to_a.zip((0..7).to_a)]
    [ (7-letter_num[1].to_i + 1), letter_hash[letter_num[0]] ]
  end

end

class ComputerPlayer

  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def get_move
    make_kill_move || make_non_check_move
  end

  def make_non_check_move
    move = make_random_move
    move = make_random_move while board.move_into_check?(*move)
    move
  end

  def make_random_move
    my_pieces = board.pieces.select {|piece| piece.color == color}
    move_piece = my_pieces.sample
    move_piece = my_pieces.sample until !move_piece.moves.empty?
    [move_piece.pos, move_piece.moves.sample]
  end

  def make_kill_move
    kill_move = nil

    my_pieces.shuffle.each do |piece|
      piece.moves.each do |move_pos|
        next if board[move_pos].nil?
        if board[move_pos].color != color
          kill_move = [piece.pos, move_pos] unless board.move_into_check?(*[piece.pos, move_pos])
          break
        end
      end
    end

    kill_move
  end

  private

  def my_pieces
    board.pieces.select {|piece| piece.color == color}
  end

end
