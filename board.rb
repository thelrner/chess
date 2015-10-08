class Board
  attr_accessor :grid

  BOARD_SIZE = 8

  BLACK_PIECES = {
    :knight => [[0,1], [0,6]],
    :rook => [[0, 0], [0, 7]],
    :queen => [[0,3]],
    :bishop => [[0, 2], [0, 5]],
    :king => [[0, 4]],
    :pawn => [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]]
  }

  WHITE_PIECES = {
    :knight => [[7,1], [7,6]],
    :rook => [[7, 0], [7, 7]],
    :queen => [[7, 3]],
    :bishop => [[7, 2], [7, 5]],
    :king => [[7, 4]],
    :pawn => [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]]
  }

  def self.on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE - 1) }
  end

  def initialize(grid = Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE)} )
    @grid = grid
  end

  def populate_board
    place_pieces(BLACK_PIECES, :black)
    place_pieces(WHITE_PIECES, :white)
  end

  def place_pieces(pieces_hash, color)
    pieces_hash.each do |piece, positions|
      positions.each do |pos|
        case piece
        when :knight then self[pos] = Knight.new(pos, self, color)
        when :rook then self[pos] = Rook.new(pos, self, color)
        when :queen then self[pos] = Queen.new(pos, self, color)
        when :bishop then self[pos] = Bishop.new(pos, self, color)
        when :king then self[pos] = King.new(pos, self, color)
        when :pawn then self[pos] = Pawn.new(pos, self, color)
        end
      end
    end
  end

  def move(start_pos, end_pos)    #safe
    move_piece = self[start_pos]

    debugger if move_piece.move_into_check?(end_pos)

    raise ChessError.new("No piece to move!") if move_piece.nil?
    raise ChessError.new("Can't move there!") unless move_piece.moves.include?(end_pos)
    raise ChessError.new("Puts you into check!") if move_piece.move_into_check?(end_pos)

    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)     # unsafe
    move_piece = self[start_pos]

    self[start_pos], self[end_pos] = nil, self[start_pos]
    self[end_pos].update_pos(end_pos)
  end

  def in_check?(color)
    king_pos = find_king(color)

    pieces.each do |piece|
      return true if piece.color != color && piece.moves.include?(king_pos)
    end

    return false
  end

  def move_into_check?(start_pos, end_pos)
    self[start_pos].move_into_check?(end_pos)
  end

  def find_king(color)
    pieces.each do |piece|
      return piece.pos if piece.is_a?(King) && piece.color == color
    end
  end

  def deep_dup
    dup_board = Board.new

    pieces.each do |piece|
      dup_piece = piece.dup
      dup_piece.board = dup_board
      dup_board[piece.pos] = dup_piece
    end

    dup_board
  end

  def over?
    checkmate?(:white) || checkmate?(:black)
  end

  def checkmate?(color)
    in_check?(color) && no_valid_moves?(color)
  end

  def no_valid_moves?(color)
    pieces.each do |piece|
      next if piece.color != color
      return false unless piece.valid_moves.empty?
    end

    true
  end

  def render
    system("clear")
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

  def pieces
    grid.flatten.compact
  end
end

class ChessError < StandardError
end
