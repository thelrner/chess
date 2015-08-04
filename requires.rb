require_relative 'board'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'sliding_piece'
require 'byebug'

b = Board.new
b.populate_board
b.move!([7, 5], [3, 1])
b.move!([0, 3], [1, 3])
b.render
p b[[1,3]].move_into_check?([0,3])
p b[[0,0]].move_into_check?([1,0])
