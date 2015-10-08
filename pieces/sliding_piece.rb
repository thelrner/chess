class SlidingPiece < Piece
  DIAGS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  STRAIGHTS = [[1, 0], [0, 1], [0, -1], [-1, 0]]

  def straight_moves
    find_moves(STRAIGHTS)
  end

  def diag_moves
    find_moves(DIAGS)
  end

  def find_moves(deltas)
    eligible_moves = []
    deltas.each do |delta|
      new_pos = pos.dup
      dx, dy = delta
      new_pos = [new_pos[0] + dx, new_pos[1] + dy]

      while Board.on_board?(new_pos)
        if !position_empty?(new_pos)
          eligible_moves << new_pos.dup if enemy?(new_pos)
          break
        end

        eligible_moves << new_pos.dup
        new_pos = [new_pos[0] + dx, new_pos[1] + dy]
      end
    end

    eligible_moves
  end
end
