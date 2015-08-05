require_relative 'board'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'sliding_piece'
require 'byebug'

b = Board.new
b.populate_board

black_queen = b[[0,3]]
p black_queen.moves
p black_queen.color

# b.move([7, 5], [3, 1])
# b.move([0, 3], [1, 3])
# b.render
# p b[[1,3]].move_into_check?([0,3])
# p b[[0,0]].move_into_check?([1,0])

pos = %w[f2 f3 e7 e5 g2 g4 d8 h4]

moves = pos.each { |pos| p b.convert_to_position(pos) }


b.move([6, 5], [5, 5])
b.render
p b.checkmate?(:white)
puts "================="
b.move([1, 4], [3, 4])
b.render
p b.checkmate?(:white)
puts "================="
b.move([6, 6], [4, 6])
b.render
p b.checkmate?(:white)
puts "================="
b.move([0, 3], [4, 7])
b.render
p b.checkmate?(:white)

# b.render
# black_pawn = b[[1, 0]]
# p black_pawn.deltas
# p black_pawn.color
# p black_pawn.possible_moves
# p black_pawn.moves
# p black_pawn.position_empty?([2, 0])
# b.move([1, 0], [3, 0])
# b.render
