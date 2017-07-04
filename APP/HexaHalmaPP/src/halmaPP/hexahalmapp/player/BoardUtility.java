package halmaPP.hexahalmapp.player;

import halmaPP.hexahalmapp.HalmaBoard;
import halmaPP.hexahalmapp.Position;
import halmaPP.preset.Move;
import java.util.ArrayList;
import java.util.Collection;
/**
 * Utility Class to generate valid moves.
 * @author Lukas Hoffmann
 * @version 1.0
 */
public class BoardUtility {

	public static final Position[] pushNeighbor = { new Position(0, -1),
			new Position(1, 0), new Position(1, 1), new Position(0, 1),
			new Position(-1, 0), new Position(-1, -1) }; 
	// to locate push neighbors
	public static final Position[] jumpNeighbor = { new Position(0, -2),
			new Position(2, 0), new Position(2, 2), new Position(0, 2),
			new Position(-2, 0), new Position(-2, -2) }; 
	// to locate jump neighbors

	/**
	 * Get all token-positions of current player.
	 * @return Array of Positions of all CPU-tokens
	 * @param board HalmaBoard
	 */
	public static Position[] getTokens(HalmaBoard board, int player) {
		Position[] a = new Position[15];
		int z = 0;
		for (int i = 0; i < 15; i++) {
			for (int j = 0; j < 11; j++) // run through the whole Board
			{
				if (board.getValue(j, i) == player) {
					a[z] = new Position(i, j); // save all token-positions of
					// current player
					z++;
				}
			}
		}
		return a;
	}

	/**
	 * Generate all possible moves for each token of current player.
	 * @param board HalmaBoard
	 * @return Collection of Objects Move with all moves for each token of current player.
	 */
	public static Collection<Move> getValidMovesForCurrentPlayer(HalmaBoard board) {
		Collection<Move> moves = new ArrayList<Move>();

		Position[] tokens = getTokens(board, board.getCurrentPlayer()); //get all tokens of current player

		for (Position position : tokens) {
			moves.addAll(generateMoves(position, board)); //add all valid moves to Collection moves
		}

		return moves;
	}

	/**
	 * Generate all possible moves of one token.
	 * @param position Position
	 * @param board HalmaBoard
	 * @return Collection of Moves
	 */
	public static Collection<Move> generateMoves(Position position,
			HalmaBoard board) {
		Collection<Move> moves = new ArrayList<Move>();
		addAllPushes(position, moves, board); //add pushes
		addAllJumps(position, moves, board);  // add jumps
		return moves;
	}

	/**
	 * Locate all jump possibilities of one Position and add them to a Collection.
	 * @param source Position
	 * @param moves	Collection of Moves
	 * @param board HalmaBoard
	 */
	private static void addAllJumps(Position source, Collection<Move> moves,
			HalmaBoard board) {
		recursivlyCreateJumps(source, new Move(source.getRow(), source.getDiagonal()), moves, board); //search jumps recursively
	}

	/**
	 * 
	 * @param source Position
	 * @param sourceMove Move
	 * @param moves Collection of Moves
	 * @param board HalmaBoard
	 */
	private static void recursivlyCreateJumps(Position source, Move sourceMove, Collection<Move> moves, HalmaBoard board) {
		Collection<Position> targets = getPossibleJumps(source, board);
		
		for (Position target : targets) {  //check if target position is already visited
			if(alreadyVisited(target, moves))
				continue;

			Move move = copyMove(sourceMove); 
			//if not save move to target position
			Move moveTarget = move;
			while(moveTarget.getNext() != null) moveTarget = moveTarget.getNext();
			moveTarget.setNext(new Move(target.getRow(), target.getDiagonal()));
			moves.add(move); 
			//and go on recursively	
			recursivlyCreateJumps(target, move, moves, board);
		}
	}
	
	/**
	 * Checks if target position is already visited
	 * @param target Position
	 * @param moves Collection of Moves
	 * @return true, if target position is already visited
	 */
	private static boolean alreadyVisited(Position target, Collection<Move> moves) {
		for (Move move : moves) {
			do {
				if(target.getRow() == move.getRow() && target.getDiagonal() == move.getDiagonal()) //target is already in collection?
					return true;
				move = move.getNext(); //go on
			} while (move != null);
		}
		
		
		return false;
	}
	/**
	 * Create a copy of the linked list of moves.
	 * @param sourceMove Move
	 * @return Move
	 */
	private static Move copyMove(Move sourceMove) {
		Move clone = new Move(sourceMove); //save start position
		Move move = clone; //pointer on start position of the Move clone
		
		Move currentSource = sourceMove;
		
		//add all Move-Objects in linked list  of sourceMove to move
		while(currentSource.getNext() != null) {   
			currentSource = currentSource.getNext();
			move.setNext(new Move(currentSource));
			move = move.getNext();
		}
		
		return clone; //reference is still on beginning
	}

	/**
	 * Locate all possible push moves for one token and create in each case a move.
	 * @param source Position
	 * @param moves Collection of moves
	 * @param board HalmaBoard
	 */
	private static void addAllPushes(Position source, Collection<Move> moves,
			HalmaBoard board) {
		Collection<Position> freeNeighbors = getFreeNeighbors(source, board);
		
		for (Position target : freeNeighbors) { //for each free neighbor create a push move
			Move move = new Move(source.getRow(), source.getDiagonal());
			move.setNext(new Move(target.getRow(), target.getDiagonal()));
			moves.add(move); //and add it to Collection
		}
	}

	/**
	 * Get Positions of free neighbors of one token. 
	 * @param in Position of one token
	 * @return ArrayList of all neighbors which are free
	 */
	private static Collection<Position> getFreeNeighbors(Position in, HalmaBoard board) {
		Collection<Position> v = new ArrayList<Position>();
		for (int i = 0; i < pushNeighbor.length; i++) {
			// check all neighbors using declared pushNeighbor array if a push-move is possible
			int x = in.getDiagonal() + pushNeighbor[i].getDiagonal();
			int y = in.getRow() + pushNeighbor[i].getRow();
			if (board.isValid(y, x) && (board.getValue(y, x) == HalmaBoard.FREE)) //neighbor valid and free?
				v.add(new Position(x, y));
		}
		return v;
	}
	
	/**
	 * Locate all possible jumps for one position 
	 * @param in Position
	 * @param board HalmaBoard
	 * @return Collection of Positions which are a possible jump for assigned position in
	 */
	private static Collection<Position> getPossibleJumps(Position in, HalmaBoard board) {
		Collection<Position> v = new ArrayList<Position>();
		for (int i = 0; i < jumpNeighbor.length; i++) { //check all jump possibilities
			
			int x_between = in.getDiagonal() + pushNeighbor[i].getDiagonal();
			int y_between = in.getRow() + pushNeighbor[i].getRow();
			if (!board.isValid(y_between, x_between)) //neighbor to jump over is valid?
				continue;
			
			int value = board.getValue(y_between, x_between);
			
			if( !(value == HalmaBoard.BLUE || value == HalmaBoard.RED) )//neighbor is a token to jump over?
				continue; 
			
			int x = in.getDiagonal() + jumpNeighbor[i].getDiagonal();
			int y = in.getRow() + jumpNeighbor[i].getRow();
			if (board.isValid(y, x)	&& (board.getValue(y, x) == HalmaBoard.FREE)) //jumpspot is free?
				v.add(new Position(x, y));
		}
		return v;
	}
  
  /*private Move getFullMove(Move move, int targetRow, int targetDiag) {
    Move follow;
    for(int i = 0; i < pushNeighbor.length; i++) {
      int row = move.getRow()+pushNeighbor[i].getRow();
      int diag = move.getDiagonal()+pushNeighbor[i].getDiagonal();
      if(diag == targetDiag && row == targetRow) {
        // found out move!
        move.setNext(new Move());
      }
    }
  }*/
}
