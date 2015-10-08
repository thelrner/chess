class Queen < Piece
  include Slideable

  def possible_moves
    diag_moves + straight_moves
  end

  def to_s
    picture = color == :white ? "\u2655" : "\u265B"
    picture.encode('utf-8')
  end
end
