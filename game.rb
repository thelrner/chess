require_relative 'board'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'sliding_piece'
require_relative 'player'
require 'byebug'

class Game

  attr_accessor :board, :current_player
  attr_reader :player1, :player2

  def initialize(board = Board.new,
    player1 = ComputerPlayer.new(:white, board),
    player2 = ComputerPlayer.new(:black, board))
    @board = board
    @player1 = player1
    @player2 = player2
    @current_player = player1
  end

  def play
    board.populate_board
    until board.over?
      board.render
      puts "Current player is: #{current_player.color}"
      begin
        player_move = current_player.get_move
        check_move(player_move)
        board.move(*player_move)
      rescue ChessError, InputError => e
        puts "#{e.message}"
        retry
      end
      switch_player
      sleep(0.15)
    end
  end

  def check_move(move)
    start_pos = move[0]       # player move fed in as 2D array, length 2
    raise ChessError.new("Not your piece") if board[start_pos].color != current_player.color
  end

  def switch_player
    self.current_player = (current_player == player2 ? player1 : player2)
  end

end

class InputError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.board.populate_board
  game.play
end
