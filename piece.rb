class Piece
  attr_accessor :pos, :board, :color

  def initialize(pos = [0,0], board = Board.new, color = :white)
    @board = board
    @pos = pos
    @color = color
  end

  def set_color(color)
    self.color = color
  end

  def receive_new_board(board)      # figure out how to send to all pieces
    self.board = board
  end

  def update_pos(pos)
    self.pos = pos
  end

  def move_into_check?(pos)
    duped_board = board.deep_dup
    duped_board.move!(self.pos, pos)

    duped_board.in_check?(color)
  end

  def valid_moves
    moves.select { |pos| move_into_check?(pos) == false }
  end

  def moves
    possible_moves.select do |pos|
      position_empty?(pos) || enemy?(pos)
    end
  end

  def enemy?(pos)
    return false if !on_board?(pos) || board[pos].nil?
    board[pos].color != color
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, board.class::BOARD_SIZE - 1) }
  end

  def position_empty?(pos)
    return false unless on_board?(pos) # for safety

    board[pos].nil?
  end
end
