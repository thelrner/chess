

class SlidingPiece < Piece
  # some functionality, needs to know what directions a piece can move in
  # (diagonal, horizontally/vertically, both)

  DIAGS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]

  def possible_moves
    moves = []
    moves += row_moves if move_dirs.include?(:rows)
    moves += col_moves if move_dirs.include?(:cols)
    moves += diag_moves if move_dirs.include?(:diags)
    moves
  end

  def row_moves     # combine with vertical? never one without other
    test_rows(:left) + test_rows(:right)
  end

  def test_rows(board = @board, pos = @pos, direction)      # can use getters?
    new_pos = pos.dup
    direction == :right ? new_pos[1] += 1 : new_pos[1] -= 1
    eligible_moves = []
    while on_board?(new_pos)
      if !position_empty?(new_pos)
        eligible_moves << new_pos.dup if enemy?(new_pos)
        break
      end
      eligible_moves << new_pos.dup
      direction == :right ? new_pos[1] += 1 : new_pos[1] -= 1
    end
    eligible_moves
  end

  # def test_rows(board = @board, pos = @pos, direction)      # can use getters?
  #   new_pos = pos.dup
  #   direction == :right ? new_pos[1] += 1 : new_pos[1] -= 1
  #   eligible_moves = []
  #   while position_empty?(new_pos) && on_board?(new_pos)
  #     eligible_moves << new_pos.dup
  #     direction == :right ? new_pos[1] += 1 : new_pos[1] -= 1
  #   end
  #   eligible_moves
  # end

  def col_moves
    # down = test_rows(board.grid.dup.transpose, pos.reverse, :left)   #down
    # up = test_rows(board.grid.dup.transpose, pos.reverse, :right)    #up
    # down.map(&:reverse) + up.map(&:reverse)
    test_cols(:down) + test_cols(:up)
  end

  def test_cols(board = @board, pos = @pos, direction)      # can use getters?
    new_pos = pos.dup
    direction == :down ? new_pos[0] += 1 : new_pos[0] -= 1
    eligible_moves = []
    while position_empty?(new_pos) && on_board?(new_pos)
      eligible_moves << new_pos.dup
      direction == :down ? new_pos[0] += 1 : new_pos[0] -= 1
    end
    eligible_moves
  end

  # def test_cols(board = @board, pos = @pos, direction)      # can use getters?
  #   new_pos = pos.dup
  #   direction == :down ? new_pos[0] += 1 : new_pos[0] -= 1
  #   eligible_moves = []
  #   while position_empty?(new_pos) && on_board?(new_pos)
  #     eligible_moves << new_pos.dup
  #     direction == :down ? new_pos[0] += 1 : new_pos[0] -= 1
  #   end
  #   eligible_moves
  # end

  def diag_moves
    eligible_moves = []
    DIAGS.each do |delta|
      new_pos = pos.dup
      dx, dy = delta
      new_pos = [new_pos[0] + dx, new_pos[1] + dy]
      while position_empty?(new_pos) && on_board?(new_pos)
        eligible_moves << new_pos.dup
        new_pos = [new_pos[0] + dx, new_pos[1] + dy]
      end
    end
    eligible_moves
  end

end

class Bishop < SlidingPiece
  def move_dirs
    [:diags]
  end

  def to_s
    "B"
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:rows, :cols]
  end

  def to_s
    "R"
  end
end

class Queen < SlidingPiece
  def move_dirs
    [:rows, :cols, :diags]
  end

  def to_s
    "Q"
  end
end
