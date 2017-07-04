
package halmaPP.hexahalmapp.player;

import halmaPP.hexahalmapp.HalmaBoard;
import halmaPP.preset.Move;
import halmaPP.preset.Player;
import halmaPP.preset.Status;


/**
 * Abstract player class. Does all the stuff that a player has to do (board-management, confirms and updates, ...).
 * Player who extend this AbstractPlayer only have to implement the requestMove()-method.
 *
 * @author Stefan Peters
 * @version 1.0
 */
public abstract class AbstractPlayer implements Player {
  // internal player board
  private HalmaBoard board;
  // color of the player
  private int color;
  // for caching the move to be executed on confirm.
  private Move move;
  // state of the player
  private PlayerState state;
  
  /**
   * Constructor creates new interal board and sets the state to Start.
   */
  public AbstractPlayer() {    
    board = new HalmaBoard();
    state = PlayerState.Start;
  }
  
  /**
   * Request a move from the player.
   * 
   * @return Player's move.
   * @throws Exception 
   * @see Player
   */
  @Override
  public Move request() throws Exception {
    if(state == PlayerState.Start) {
      color = HalmaBoard.RED;
      state = PlayerState.Request;
    }
    if(state == PlayerState.Request) {
      state = PlayerState.Confirm;
      move = requestMove();      
      return move;
    } else {
      throw new Exception("Wrong state!");
    }
  }
  
  /**
   * All players need to implement this method!
   * 
   * @return Player's move
   */
  protected abstract Move requestMove();
  
  /**
   * Confirms the player's move.
   * 
   * @param boardStatus Status of the controlBoard
   * @throws Exception 
   * @see Player
   */
  @Override
  public void confirm(Status boardStatus) throws Exception {
    if(state == PlayerState.Confirm) {
      state = PlayerState.Update;
      updateBoard(move, boardStatus);      
      if(boardStatus.isILLEGAL()) {
        state = PlayerState.Request;
      }
    } else {
      throw new Exception("Wrong state!");
    }
  }
  
  /**
   * Updates the player with the opponent's move.
   * 
   * @param opponentMove Opponent's move.
   * @param boardStatus Status of the controlBoard
   * @throws Exception 
   * @see Player
   */
  @Override
  public void update(Move opponentMove, Status boardStatus) throws Exception {
    if(state == PlayerState.Start) {
      color = HalmaBoard.BLUE;
      state = PlayerState.Update;
    }
    if(state == PlayerState.Update) {
      state = PlayerState.Request;
      updateBoard(opponentMove, boardStatus);      
    } else {
      throw new Exception("Wrong state!");
    }
  }
  
  /**
   * Set the move. Used by request() and update().
   * 
   * @param move
   * @param boardStatus
   * @throws Exception 
   */
  private void updateBoard(Move move, Status boardStatus) throws Exception {
    System.out.println("Board of "+HalmaBoard.colorToString(color)+" player:\n"+board);    
    if(board.setMove(move).getValue() != boardStatus.getValue()) {      
      // move not possible: throw exception
      throw new Exception();
    } else if(!boardStatus.isOK()) {
      // state = PlayerState.End;
      // ToDo: Aufbessern
    }   
  }
  
  /**
   * Returns the color of the player.
   * 
   * @return Returns the color of the player
   */
  public int getColor() {
    return color;
  }
  
  /**
   * Returns the player's board. For use in subclasses.
   * 
   * @return Returns the board
   */
  protected HalmaBoard getBoard() {
    return board;
  }
  
  /**
   * Returns the current state of the player.
   * 
   * @return Current state of the player (Start, Request, Confirm, Update, End)
   * @see PlayerState
   */
  public PlayerState getState() {
    return state;
  }
}
