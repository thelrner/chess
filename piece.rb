class Piece
  attr_accessor :pos, :board, :color

  def initialize(pos = [0,0], board = Board.new, color = :white)
    @board = board
    @pos = pos
    @color = color
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
    moves.select { |pos| !move_into_check?(pos) }
  end

  def moves
    possible_moves.select do |pos|
      position_empty?(pos) || enemy?(pos)
    end
  end

  def enemy?(pos)
    return false if position_empty?(pos)
    board[pos].color != color
  end

  def position_empty?(pos)
    board[pos].nil?
  end
end
