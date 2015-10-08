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
    picture = color == :white ? "\u2658" : "\u265E"
    picture.encode('utf-8')
  end
end
