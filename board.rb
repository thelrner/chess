class Board
  attr_accessor :grid

  BOARD_SIZE = 8

  def initialize(grid = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE)} )
    @grid = grid
    # populate_board
  end

  def in_check?(color)
    king_pos = find_king(color)

    self.grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        return true if piece.color != color && piece.moves.include?(king_pos)   #moves
      end
    end

    return false
  end

  def deep_dup
    dup_board = self.dup
    dup_board.grid = duplicate_grid(grid)
    dup_board
  end

  def duplicate_grid(array)
    return nil if array.nil?
    return array.dup if !array.is_a?(Array)
    array.map {|subarray| duplicate_grid(subarray)}
  end

  def move!(start_pos, end_pos)
    move_piece = self[start_pos]
    raise "No piece to move!" if move_piece.nil?
    raise "Can't move there!" unless move_piece.moves.include?(end_pos)

    self[start_pos], self[end_pos] = nil, self[start_pos]
    self[end_pos].update_pos(end_pos)
    send_board_to_pieces
  end

  def find_king(color)
    self.grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i,j] if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def populate_board
    place_knights
    place_rooks
    place_queens
    place_bishops
    place_kings
    mark_sides
    send_board_to_pieces
  end

  def mark_sides
    (0..1).each do |row_i|
      grid[row_i].each do |piece|
        next if piece.nil?            # delete line with pawns
        piece.set_color(:black)
      end
    end
  end

  def send_board_to_pieces
    grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        piece.receive_new_board(self)
      end
    end
  end

  def render
    to_print = grid.map do |row|
      row.map { |piece| piece.nil? ? " " : piece.to_s }.join(" ")
    end

    puts to_print.join("\n")
  end

  def [](pos)
    x, y = pos[0], pos[1]
    grid[x][y]
  end

  def []=(pos, mark)
    x, y = pos[0], pos[1]
    self.grid[x][y] = mark
  end

  def convert_to_position(letter_num)           # converts a1 to [0,0]
    letter_hash = Hash[("a".."h").to_a.zip((0..7).to_a)]
    [ (7-letter_num[1].to_i + 1), letter_hash[letter_num[0]] ]
  end

  private

  def place_knights
    knight_pos = [[7,1], [7, 6], [0,1], [0,6]]
    knight_pos.each { |pos| self[pos] = Knight.new(pos) }
  end

  def place_rooks
    rooks_pos = [[7,0], [7, 7], [0, 0], [0, 7]]
    rooks_pos.each { |pos| self[pos] = Rook.new(pos) }
  end

  def place_queens
    queens_pos = [[7, 3], [0,3]]
    queens_pos.each { |pos| self[pos] = Queen.new(pos) }
  end

  def place_bishops
    bishops_pos = [[7, 2], [7, 5], [0, 2], [0, 5]]
    bishops_pos.each { |pos| self[pos] = Bishop.new(pos) }
  end

  def place_kings
    kings_pos = [[7, 4], [0, 4]]
    kings_pos.each { |pos| self[pos] = King.new(pos) }
  end

end
