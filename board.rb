class Board
  attr_accessor :grid

  BOARD_SIZE = 8

  def initialize(grid = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE)} )
    @grid = grid
    populate_board
  end

  def in_check?(color)
    king_pos = find_king(color)

    self.grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        debugger if piece.moves.nil?
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

  def move(start_pos, end_pos)    #safe
    move_piece = self[start_pos]
    raise "No piece to move!" if move_piece.nil?
    raise "Can't move there!" unless move_piece.moves.include?(end_pos)
    raise "Puts you into check!" if move_piece.move_into_check?(end_pos)
    self[start_pos], self[end_pos] = nil, self[start_pos]
    self[end_pos].update_pos(end_pos)
    send_board_to_pieces
  end

  def move!(start_pos, end_pos)     # unsafe
    move_piece = self[start_pos]
    raise "No piece to move!" if move_piece.nil?
    raise "Can't move there!" unless move_piece.moves.include?(end_pos)

    self[start_pos], self[end_pos] = nil, self[start_pos]
    self[end_pos].update_pos(end_pos)
    send_board_to_pieces
  end

  def checkmate?(color)
    in_check?(color) && no_valid_moves?(color)
  end

  def over?
    checkmate?(:white) || checkmate?(:black)
  end

  def no_valid_moves?(color)
    self.grid.each do |row|
      row.each do |piece|
        next if piece.nil? || piece.color != color
        #debugger if piece.valid_moves.empty? == false
        return false unless piece.valid_moves.empty?
      end
    end

    true
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
    place_pawns
    mark_sides
    send_board_to_pieces
  end

  def mark_sides
    (0..1).each do |row_i|
      grid[row_i].each { |piece| piece.set_color(:black) }
    end

    (6..7).each do |row_i|
      grid[row_i].each { |piece| piece.set_color(:white) }
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
    puts "  " + ("a".."h").to_a.join(" ")
    left_index = 8

    grid.each do |row|
      pieces = row.map { |piece| piece.nil? ? "_" : piece.to_s }.join(" ")

      puts left_index.to_s + ' ' + pieces
      left_index -= 1
    end

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
    knight_pos.each { |pos| self[pos] = Knight.new(pos, self) }
  end

  def place_rooks
    rooks_pos = [[7,0], [7, 7], [0, 0], [0, 7]]
    rooks_pos.each { |pos| self[pos] = Rook.new(pos, self) }
  end

  def place_queens
    queens_pos = [[7, 3], [0,3]]
    queens_pos.each { |pos| self[pos] = Queen.new(pos, self) }
  end

  def place_bishops
    bishops_pos = [[7, 2], [7, 5], [0, 2], [0, 5]]
    bishops_pos.each { |pos| self[pos] = Bishop.new(pos, self) }
  end

  def place_kings
    kings_pos = [[7, 4], [0, 4]]
    kings_pos.each { |pos| self[pos] = King.new(pos, self) }
  end

  def place_pawns
    [1, 6].each do |row_i|
      grid[row_i].each_index do |col_i|
        pos = [row_i, col_i]
        self[pos] = Pawn.new(pos, self)
      end
    end
  end

end
