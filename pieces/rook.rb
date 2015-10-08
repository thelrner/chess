class Rook < SlidingPiece
  def possible_moves
    straight_moves
  end

  def to_s
    picture = color == :white ? "\u2656" : "\u265C"
    picture.encode('utf-8')
  end
end
