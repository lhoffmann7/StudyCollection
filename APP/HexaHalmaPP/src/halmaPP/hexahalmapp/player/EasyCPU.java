package halmaPP.hexahalmapp.player;

import halmaPP.hexahalmapp.HalmaBoard;
import halmaPP.preset.Move;
import java.util.ArrayList;
import java.util.Random;
/**
 * 
 * @author Lukas Hoffmann
 * @version 1.0
 */
public class EasyCPU extends AbstractPlayer{

	HalmaBoard cpuBoard;

    
	public EasyCPU()
	{
	  cpuBoard = getBoard();
	}

	/**
	 * Select random one token, check which moves are possible, if jump and push are possible choose random one of them and construct move.
	 * @return Move
	 */
	@Override
	public Move requestMove() {
	 //get all possible moves of each token 
	 ArrayList<Move> possibleMoves = (ArrayList<Move>) BoardUtility.getValidMovesForCurrentPlayer(cpuBoard);
	 int z = randomNumber(possibleMoves.size()); //pick one move random
	 return possibleMoves.get(z); //return this move
	}
	
	/**
	 * Creates a random number in interval [0,high)
	 * @param high 
	 * @return random number
	 */
	
	private int randomNumber(int high) 
	{
		Random rnd = new Random();
		int z = rnd.nextInt(high);
		return z;
	}
	
}