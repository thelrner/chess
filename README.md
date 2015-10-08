# CLI Chess

Chess implemented in the command line. Adopts OO best practices. Inheritance and modular extension between "archetypal" pieces and specific piece move-types. Duck typing between human and computer player API.

Game supports, one, two, or even zero human players. "Killer" AI attempts to take pieces when possible.

## Running the game
To run the game, cd into the chess directory and run:

```
ruby game.rb 2
```
This will create a 2-player game. Replace 2 with the number of human players.

Enter moves in chess notation.
f4, f6 moves the f4 pawn to f6.

## Watch epic robot battle
```
ruby game.rb 0
```
