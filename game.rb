require_relative 'board'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'sliding_piece'
require 'byebug'

class Game

  attr_accessor :board, :current_color

  def initialize(board = Board.new)
    @board = board
    @current_color = :white
  end

  def play
    board.populate_board
    until board.over?
      board.render
      puts "Current player is: #{current_color}"
      begin
        player_move = get_move
        check_move(player_move)  
        board.move(*player_move)
      rescue ChessError => e
        puts "#{e.message}"
        retry
      end
      switch_player
    end
  end

  def get_move
    begin
    puts "Where do you move? ie. f2, f5"
    move = gets.chomp
    validate_input(move)
    rescue InputError => e
      puts "#{e.message}"
      retry
    end
    move = move.split(',').map(&:strip)
    move.map {|coord| convert_to_position(coord)}
  end

  def convert_to_position(letter_num)
    letter_hash = Hash[("a".."h").to_a.zip((0..7).to_a)]
    [ (7-letter_num[1].to_i + 1), letter_hash[letter_num[0]] ]
  end

  def check_move(move)
    start_pos = move[0]
    raise ChessError.new("Not your piece") if board[start_pos].color != current_color
  end

  def switch_player
    self.current_color = current_color == :white ? :black : :white
  end

  def validate_input(input)
    match_data = input.match(/\A[a-h][1-8], ?[a-h][1-8]\z/)
    raise InputError.new("Invalid input") if match_data.nil?
  end
end

class InputError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.board.populate_board
  game.play
end
