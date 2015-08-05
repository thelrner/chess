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

class Pawn < SteppingPiece

  attr_accessor :deltas, :first_move_delta

  def initialize(pos = [0,0], board = Board.new, color = :white)
    super

    @initial_pos = pos
  end

  def set_color(color)
    super color

    set_deltas
  end

  def set_deltas
    if color == :white
      @deltas = [[-1, 1], [-1, 0], [-1, -1]]
      @first_move_delta = [-2, 0]
    else
      @deltas = [[1, 1], [1, 0], [1, -1]]
      @first_move_delta = [2, 0]
    end
  end

  def possible_moves
    deltas.map { |x, y| [pos[0] + x, pos[1] + y] }
  end

  def moves
    possibles = possible_moves.select {|pos| on_board?(pos)}

    possibles.select! do |pos|
      case pos
      when possibles.first
        enemy?(pos) ? true : false
      when possibles.last
        enemy?(pos) ? true : false
      when possibles[1]
        position_empty?(pos) ? true : false
      end
    end

    possibles << initial_move if initial_move
    possibles
  end

  def initial_move
    return false if pos != @initial_pos

    new_pos = [pos[0] + first_move_delta[0], pos[1]]
    return new_pos if position_empty?(new_pos)

    false
  end

  def to_s
    "P"
  end

end
