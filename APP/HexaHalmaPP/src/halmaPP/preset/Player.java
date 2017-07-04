package halmaPP.preset;

import java.rmi.*;

/**
 * Player-interface.
 * 
 */
public interface Player extends Remote {
  /**
   * Requests a move from the player.
   * 
   * @return Move of the player.
   * @throws Exception
   * @throws RemoteException 
   */
    Move request() throws Exception, RemoteException; 
    
    /**
     * Confirms the move to the player.
     * 
     * @param boardStatus Status of the control-board.
     * @throws Exception
     * @throws RemoteException 
     */
    void confirm(Status boardStatus) throws Exception, RemoteException;
    
    /**
     * Pass the opponent's move to the player.
     * 
     * @param opponentMove Opponent's move
     * @param boardStatus Board-status after opponent's move
     * @throws Exception
     * @throws RemoteException 
     */
    void update(Move opponentMove, Status boardStatus) throws Exception, RemoteException;
}
