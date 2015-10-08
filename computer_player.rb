class ComputerPlayer
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def get_move
    sleep 0.35
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
