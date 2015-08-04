
class SteppingPiece < Piece
  def possible_moves
    self.class::DELTAS.map { |x, y| [pos[0] + x, pos[1] + y] }
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

  def to_s
    "K"
  end

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

  def to_s
    "H"
  end

end
