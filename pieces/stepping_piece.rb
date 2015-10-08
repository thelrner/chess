module Steppable
  def possible_moves
    self.class::DELTAS.map { |x, y| [pos[0] + x, pos[1] + y] }.select do |pos|
      Board.on_board?(pos)
    end
  end
end
