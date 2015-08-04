

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

  def receive_new_position(pos)
    self.pos = pos
  end

  def moves
    possible_moves.select do |pos|
      ( position_empty?(pos) || enemy?(pos) ) && on_board?(pos)
    end
  end

  def enemy?(pos)
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
