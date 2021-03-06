require_relative 'board'
require_relative 'pieces'
require_relative 'computer_player'
require_relative 'human_player'
require 'byebug'

class Game

  attr_accessor :board, :current_player
  attr_reader :player1, :player2

  def initialize(board = Board.new,
    player1 = HumanPlayer.new(:white, board),
    player2 = ComputerPlayer.new(:black, board))
    ARGV.clear
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
    start_pos = move[0]
    raise ChessError.new("Not your piece") if board[start_pos].color != current_player.color
  end

  def switch_player
    self.current_player = (current_player == player2 ? player1 : player2)
  end

end

class InputError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new

  case ARGV[0]
  when '0'
    player1 = ComputerPlayer.new(:white, board)
    player2 = ComputerPlayer.new(:black, board)
  when '1'
    player1 = HumanPlayer.new(:white, board)
    player2 = ComputerPlayer.new(:black, board)
  when '2'
    player1 = HumanPlayer.new(:white, board)
    player2 = HumanPlayer.new(:black, board)
  end

  game = Game.new(board, player1, player2)
  game.play
end
