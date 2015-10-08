class King < Piece
  include Steppable

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
    picture = color == :white ? "\u2654" : "\u265A"
    picture.encode('utf-8')
  end
end
