package halmaPP.hexahalmapp.player;

import halmaPP.hexahalmapp.HalmaBoard;
import halmaPP.hexahalmapp.Position;
import halmaPP.preset.Move;
import halmaPP.preset.Status;
import java.util.Collection;

/**
 * MediumCPU class. This class contains the logic of the computer player using
 * artificial intelligence.
 * 
 * @author Gleb
 * @version 1.0
 */
public class MediumCPU extends AbstractPlayer {

	public MediumCPU() {
		super();
	}

	/**
	 * Estimates the weight of the class for the selected position
	 * 
	 * @param board
	 * @param player
	 * @return estimated weight
	 */

	public int getEstimate(HalmaBoard board, int player) {
		// boolean wasRed = board.getCurrentPlayer() == HalmaBoard.BLUE;

		Position[] tokens = BoardUtility.getTokens(board, player);
		int[] classes = new int[] { 6, 3, 3, 3 };

		int est = 0;
		for (Position token : tokens) {
			int x = token.getRow();
			int y = token.getDiagonal();
			int classN = getClass(x, y);
			classes[classN - 1]--;
			if (player == HalmaBoard.BLUE)
				est += x + y; // (!isRed)
			else
				est += 2 * x - y + 10;
		}
		int K = Math.abs(classes[0]) + Math.abs(classes[1])
				+ Math.abs(classes[2]) + Math.abs(classes[3]);
		est = est - 5 * K;
		return est;
	}

	/**
	 * Returns class of position (x,y)
	 * 
	 * @param x
	 *            coordinates
	 * @param y
	 *            coordinates
	 * @return Class of position (x,y)
	 */
	public int getClass(int x, int y) {
		int classN = 0;
		if ((x % 2 == 0) && (y % 2 == 0))
			classN = 1;
		if ((x % 2 == 0) && (y % 2 == 1))
			classN = 2;
		if ((x % 2 == 1) && (y % 2 == 1))
			classN = 3;
		if ((x % 2 == 1) && (y % 2 == 0))
			classN = 4; // y%2 == 0
		return classN;
	}

	/**
	 * Contains main logic of the computer player
	 * 
	 * @return Move
	 */
	@Override
	protected Move requestMove() {

		int bestEst = Integer.MIN_VALUE;

		int playerColor = getBoard().getCurrentPlayer();
		int opponentColor;
		if (playerColor == HalmaBoard.BLUE) {
			opponentColor = HalmaBoard.RED;
		} else {
			opponentColor = HalmaBoard.BLUE;
		}

		Move bestMove = null;

		Collection<Move> moves = BoardUtility
				.getValidMovesForCurrentPlayer(getBoard()); // for each of them
															// find all possible
															// reachable
															// positions
		for (Move curMove : moves) {

			HalmaBoard bCopy = (HalmaBoard) getBoard().clone(); // create a copy
																// of board
			bCopy.doMove(curMove);
			bCopy.nextPlayer();

			// test whether a player has won the game
			if (isWin(bCopy))
				return curMove;

			int estX = getEstimate(bCopy, playerColor); // estimate X
														// coefficient for
														// possible turn

			Collection<Move> enemyMoves = BoardUtility
					.getValidMovesForCurrentPlayer(bCopy);
			
			for (Move enemyMove : enemyMoves) {
				HalmaBoard eCopy = (HalmaBoard) bCopy.clone();  // create a copy
																// of board
				eCopy.doMove(enemyMove);
				eCopy.nextPlayer();

				// test whether the oppponent has won the game
				if (isWin(eCopy)) {
					if (bestMove == null)
						bestMove = curMove;
					continue;
				}

				int estY = getEstimate(eCopy, opponentColor);

				int curEst = estX - estY;
				if (curEst > bestEst) {
					bestEst = curEst;
					bestMove = curMove;
				}
			}
		}
		return bestMove;
	}

	/**
	 * checks whether a player has won the game
	 * 
	 * @param board
	 * @return true, when a player has won the game
	 */

	private boolean isWin(HalmaBoard board) {
		boolean wasRed = board.getCurrentPlayer() == HalmaBoard.BLUE;
		board.isWin();
		Status status = board.getStatus();
		if (wasRed)
			return status.isREDWIN();
		else
			return status.isBLUEWIN();
	}
}
