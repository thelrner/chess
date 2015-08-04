class Piece
  attr_accessor :pos, :board

  def initialize(pos = [0,0], board = Board.new)
    @board = board
    @pos = pos
  end

  # update position and board methods

  def moves
  end
end

class SlidingPiece < Piece
  # some functionality, needs to know what directions a piece can move in
  # (diagonal, horizontally/vertically, both)

  def moves
    row_moves + col_moves + diag_moves
  end

  def row_moves     # combine with vertical? never one without other
  end

  def col_moves
  end

  def diag_moves
  end



end

class Bishop < SlidingPiece
  def move_dirs
    [:diags]
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:rows, :cols]
  end
end

class Queen < SlidingPiece
  def move_dirs
    [:rows, :cols, :diags]
  end
end

class SteppingPiece < Piece
  def moves
    possible_moves = self.class::DELTAS.map { |x, y| [pos[0] + x, pos[1] + y] }
  end

end

class King < SteppingPiece

  DELTAS = [
    [1, 1],
    [1, 0],
    [1, -1],
    [0, 1],
    [0, -1],
    [-1, 1],
    [-1, 0],
    [-1, -1]
  ]

end

class Knight < SteppingPiece

  DELTAS = [
    [2, -1],
    [2, 1],
    [1, -2],
    [1, 2],
    [-1, 2],
    [-1, -2],
    [-2, -1],
    [-2, 1]
  ]

end
