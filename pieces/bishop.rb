class Bishop < Piece
  include Slideable
  
  def possible_moves
    diag_moves
  end

  def to_s
    picture = color == :white ? "\u2657" : "\u265D"
    picture.encode('utf-8')
  end
end
