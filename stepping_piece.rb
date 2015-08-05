class SteppingPiece < Piece

  def possible_moves
    self.class::DELTAS.map { |x, y| [pos[0] + x, pos[1] + y] }.select do |pos|
      Board.on_board?(pos)
    end
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
    picture = color == :white ? "\u2654" : "\u265A"
    picture.encode('utf-8')
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
    picture = color == :white ? "\u2658" : "\u265E"
    picture.encode('utf-8')
  end

end

class Pawn < Piece

  attr_accessor :first_move_delta, :straight_delta, :diag_delta
  attr_reader :initial_pos

  def initialize(pos = [0,0], board = Board.new, color = :white)
    super
    @initial_pos = pos
    set_deltas
  end

  def set_deltas
    if color == :white
      @straight_delta =  [-1, 0]
      @diag_delta = [[-1, 1], [-1, -1]]
      @first_move_delta = [-2, 0]
    else
      @straight_delta = [1, 0]
      @diag_delta = [[1, 1], [1, -1]]
      @first_move_delta = [2, 0]
    end
  end

  def moves
    straight_move + diag_move + initial_move
  end

  def straight_move
    new_pos = [pos[0] + straight_delta[0], pos[1]]
    Board.on_board?(new_pos) ? [new_pos] : []
  end

  def diag_move
    moves = []
    diag_delta.each do |delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
      next unless Board.on_board?(new_pos)
      moves << new_pos.dup if enemy?(new_pos)
    end
    moves
  end

  def initial_move
    new_pos = [pos[0] + first_move_delta[0], pos[1]]
    pos == initial_pos ? [new_pos] : []
  end

  def to_s
    picture = color == :white ? "\u2659" : "\u265F"
    picture.encode('utf-8')
  end

end
