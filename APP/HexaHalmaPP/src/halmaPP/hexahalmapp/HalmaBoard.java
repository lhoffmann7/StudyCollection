
package halmaPP.hexahalmapp;


import halmaPP.hexahalmapp.player.BoardUtility;
import halmaPP.preset.Move;
import halmaPP.preset.Status;


/**
 * Board-class. All the core-functionality of the game is in here. 
 * 
 * @author Wiebke Tornow
 * @author Stefan Peters
 * @version 0.9
 */
public class HalmaBoard {
  // constants for the fields of the board
  public static final int RED = 1;
  public static final int BLUE = 2;
  public static final int INVALID = -1;
  public static final int FREE = 0;
  
  // storing the data of the board
  private HalmaBoardNode[][] boardNodes;
  
  private Status status;
  private int currentPlayer;
  private boolean debug;
  
  /**
   * Contructor initializes a board with all figures in start position and Status is OK
   */
  public HalmaBoard() {
    boardNodes = new HalmaBoardNode[11][15];
    status = new Status(Status.OK);
    // Red player always begins the game
    currentPlayer = HalmaBoard.RED;
    debug = false;
    initialize();    
  }
  
  /**
   * Initialization of the board. Used only in the constructor.
   */
  private void initialize() {
    // Using the "isValid"-method to determine which fields are within the actual board
    for(int row = 0; row < 11; row++) {
     for(int diagonal = 0; diagonal < 15; diagonal++) {
        boardNodes[row][diagonal] = new HalmaBoardNode();
        if(!isValid(row, diagonal)) {
          setValue(row, diagonal, HalmaBoard.INVALID);
          boardNodes[row][diagonal].setType(HalmaBoardNodeType.Invalid);
        }
      }
    }
    // set blue figures to start-position
    for(int diagonal = 0; diagonal < 5; diagonal++) {
      for(int row = 0; row <= 4 - diagonal; row++) {
        setValue(row,diagonal,HalmaBoard.BLUE);
        boardNodes[row][diagonal].setType(HalmaBoardNodeType.BlueStart);
      }
    }
    // set red figures to start-position
    for(int row = 0; row < 5; row++) {
      for(int diagonal = 6; diagonal < 15; diagonal++) {
        if(isValid(row, diagonal) && row - diagonal/2 < -2) {
          setValue(row,diagonal,HalmaBoard.RED);
          boardNodes[row][diagonal].setType(HalmaBoardNodeType.RedStart);
        }
      }
    }
    // sets the node type for the goals
    // blue goals
    for(int diag = 10; diag < 15; diag++) {
      for(int row = 10; row >= 20-diag; row--) {
        if(isValid(row, diag)) boardNodes[row][diag].setType(HalmaBoardNodeType.BlueGoal);  	
      }
    }
    // red goals
    for(int diag = 2; diag < 11; diag++) {
      for(int row = 6; row < 11; row++) {
        if(isValid(row, diag) && row - (diag + 1) / 2 > 4) {
          if(isValid(row, diag)) boardNodes[row][diag].setType(HalmaBoardNodeType.RedGoal);
        }
      }
    }
    // one mixed goal
    boardNodes[10][10].setType(HalmaBoardNodeType.MixedGoal);
  }
  
  /**
   * Determines if a field (row, diagonal) is an actual field of the board.
   * ToDo: Switch row and diagonal!
   *
   * @param row
   * @param diagonal
   * @return True, if the position is a valid one.
   */
  public boolean isValid(int row, int diagonal) {
    if(diagonal < 0 || row < 0 || diagonal > 14 || row > 10) return false;
    if(row - diagonal > 4) return false;	
    if(diagonal > 10 && row - diagonal < -10) return false;
    return true;
  }

  /**
  *	Sends a move for the current player to the playboard
  *
  * @param move Move or moves for the current player  
  * @return Returns the status after the move is set. 
  */
  public Status setMove(Move move) {
    if(move == null) {
      if(currentPlayer == HalmaBoard.BLUE) {
        if(debug) System.out.println("Blue player gave up.");
        status = new Status(Status.REDWIN);
      }
      else {
        status = new Status(Status.BLUEWIN);
        if(debug) System.out.println("Red player gave up.");
      }
      return status;
    }
    if(isCorrect(move)) {
      status = new Status(Status.OK);
      // Do the move.
      doMove(move);
      isWin();
      nextPlayer();
      if(debug) System.out.println("Move is correct.");

      /* After the move, you might think you have to check,
       * if one player can't do anything anymore (so it would be a draw).
       * But that is not necessary since it is not possible on the board.
       * One player does not have enough figures to surround all figures of the opponent.
       */
    } 
    else {
      status = new Status(Status.ILLEGAL);
    }
    return status;
  }
  
  /**
  * Checks if a move is correct
  * @param move
  * @return true if the mobe is correct, else false
  */
  public boolean isCorrect(Move move) {
    // Checks if the move starts with the current player.
    if(getValue(move.getRow(),move.getDiagonal()) != getCurrentPlayer()) {
      if(debug) System.out.println("The move doesn't start with your figure!");
      return false;
    }
    if(move.getNext() == null) {
      if(debug) System.out.println("The target of the move is missing!");
      return false;
    }
    if(isCorrectMove(move)) {
      return true;
    }
    if(isCorrectJump(move) && !alreadyVisited(move, move.getNext())) {
      return true;
    }
    return false;
  }

  /**
   * Sets the current player to the next player.
   */
  public void nextPlayer() {
    if(currentPlayer == HalmaBoard.BLUE) {
      currentPlayer = HalmaBoard.RED;
    } else {
      currentPlayer = HalmaBoard.BLUE;
    }
  }

  /**
   * Executes the move or jump. The move HAS to be verified before using this method!
   * 
   * @param move Move to execute on the board
   */
  public void doMove(Move move) {
    // determine target of the move
    Move lastMove = move;
    while(lastMove.getNext() != null) {
      lastMove = lastMove.getNext();
    }
    // switch target with original position
    setValue(lastMove.getRow(),lastMove.getDiagonal(),getValue(move.getRow(),move.getDiagonal()));
    setValue(move.getRow(),move.getDiagonal(),0);
  }

  /**
   * Checks if a field on the board is free (so no figure stands there).
   * 
   * @param diagonal
   * @param row
   * @return Returns false if there is any player on the field OR if it is not valid.
   */
  private boolean isFree(int row, int diagonal) {
    if(getValue(row, diagonal) == 0) {
      return true;
    }
    return false;
  }

  /**
   * Checks if the target and source positions are neighbors.
   * 
   * @param sourceDiagonal
   * @param sourceRow
   * @param targetDiagonal
   * @param targetRow
   * @return True, if they are neighbors.
   */
  private boolean isNeighbor(int sourceRow, int sourceDiagonal, int targetRow, int targetDiagonal) {
    for(int i = 0; i < BoardUtility.pushNeighbor.length; i++) {
      int row = sourceRow + BoardUtility.pushNeighbor[i].getRow();
      int diag = sourceDiagonal + BoardUtility.pushNeighbor[i].getDiagonal();
      if(row == targetRow && diag == targetDiagonal) {
        return true;
      }
    }
    return false;
  }

  /**
   * Checks if the move is a correct move (and not a jump).
   * 
   * @param move Move to check
   * @return True if the move is a correct move.
   */
  public boolean isCorrectMove(Move move) {
    Move next = move.getNext(); 
    if(next == null) {
      return false;
    }
    // could have used move.getNext() but it is shorter and better to read and write just next
    // target of a correct move should be free and a neighbor
    if(isNeighbor(move.getRow(), move.getDiagonal(), next.getRow(), next.getDiagonal()) 
      && isFree(next.getRow(), next.getDiagonal())) {
      return true;
    }
    return false;
  }

  /**
   * Checks if a jump from move to move.next is possible.
   * ToDo: Should not be public!?
   * 
   * @param move Move to check.
   * @return True, if the jump is possible.
   */
  public boolean isCorrectJump(Move move) {
    if(move.getNext() == null) { 
      // The situation, that there is only one move, is handled by isCorrect()
      return true;
    }
    if((move.getDiagonal()  +   move.getNext().getDiagonal()) % 2 != 0) {
      return false;
    }
    if((move.getRow()       +   move.getNext().getRow()) % 2 != 0) {
      return false;
    }
    // the feld between target and start has to be the neighbor of both of them
    // if there are 2 felds between them, we have checked it with % 2 != 0,
    // this feld shold not be free
    // but the target has to be free
    int betweenDiagonal = (move.getDiagonal()  +   move.getNext().getDiagonal()) / 2;
    int betweenRow      = (move.getRow()       +   move.getNext().getRow()) / 2;
    if(isNeighbor(move.getRow(), move.getDiagonal(), betweenRow, betweenDiagonal)
      && !isFree(betweenRow, betweenDiagonal) 
      && isFree(move.getNext().getRow(), move.getNext().getDiagonal())) {
      return isCorrectJump(move.getNext());
    }
    return false;
  }

  /**
   * Checks a move for double visited positions. 
   * 
   * @param move
   * @param nextMove
   * @return True if there's a double visited position.
   */
  private boolean alreadyVisited(Move move, Move nextMove) {
    if(nextMove == null) {
      if(move.getNext() == null) {
        return false;
      }
      return alreadyVisited(move.getNext(), move.getNext().getNext());
    }
    if(move.getDiagonal() != nextMove.getDiagonal() || move.getRow() != nextMove.getRow()) {
      return(alreadyVisited(move, nextMove.getNext()));
    }
    else {
      return true;
    }
  }

  /**
  *	Returns the current status of the board
  *
  *	@return Status-object for the current status
  */
  public Status getStatus() {
    return status;
  }

  /**
  *	Returns a String-representation of the board
  */
  @Override
  public String toString() {
    String s = "";
    for(int row = 10; row >= 0; row--) {
      // row coordinates
      if(row<10) s += " ";
      s += row+"  ";
      // spaces for the hexagon form
      for(int i = 0; i < Math.abs(row - 4); i++) {
        s += " ";
      }
      // valid board values with spaces in between
      for(int diagonal = 0; diagonal < 15; diagonal++) {
        if(isValid(row, diagonal))  s += getValue(row,diagonal)+" ";
      }
      // diagonal coordinates 12 to 14
      if(row < 3) {
        s += "  "+(12+row);         
      }
      s += "\n";
    }
    // diagonal coordinal 11
    for(int i = 0; i < 31; i++) s += " ";
    s += "11\n";
    // diagonal coordinates 1 to 10
    for(int i = -10; i<11; i++) {
      if(i>=0) {
        s += i+" ";
      } else {
        s += " ";
      }
    }
    s += "\n";
    return s;
  }

  /**
  *	Returns the current player
  *
  *	@return Red player: HalmaBoard.RED, blue player: HalmaBoard.BLUE
  */
  public int getCurrentPlayer() {
    return currentPlayer;
  }
  
  
    
  /**
    * Checks, if any player won, and sets the status accordingly.
    * Note that if both player's target areas are fully occupied, 
    * the player who did the last move wins
    * 
    */
  public void isWin() {
    if(isBlueWin()) {
        status = new Status(Status.BLUEWIN);
    }
    if(isRedWin()) {
      if(status.getValue() == Status.BLUEWIN) {
        if(getCurrentPlayer() == HalmaBoard.RED) {
          status = new Status(Status.REDWIN);
        }
      } else {
        status = new Status(Status.REDWIN);
      }
    }
  }
    
  /**
    * Checks, if the target area of the blue player is fully occupied
    * 
    * @return true, if area is fully occupied
    */
  private boolean isBlueWin() {
    for(int row = 5; row < 11; row++) {
      for(int diag = 0; diag < 15; diag++) {
        if((boardNodes[row][diag].getType() == HalmaBoardNodeType.BlueGoal
            || boardNodes[row][diag].getType() == HalmaBoardNodeType.MixedGoal)
                && boardNodes[row][diag].getValue() == 0) {
          return false;
        }
      }
    }
    return true;
  }
 
  /**
    * Checks, if the target area of the red player is fully occupied
    * 
    * @return true, if area is fully occupied
    */
  private boolean isRedWin() {
    for(int row = 6; row < 11; row++) {
      for(int diag = 0; diag < 15; diag++) {
        if((boardNodes[row][diag].getType() == HalmaBoardNodeType.RedGoal
            || boardNodes[row][diag].getType() == HalmaBoardNodeType.MixedGoal)
                && boardNodes[row][diag].getValue() == HalmaBoard.FREE) {
          return false;
        }
      }
    }
    return true;
  }
  
  /**
   * Sets the debug switch.
   * 
   * @param d if d is true the HalmaBord is printed for every step
   */
  public void setDebug(boolean d) {
    debug = d;
  }

  /**
   * Returns the board value for (row,diagonal).
   * 
   * @param row
   * @param diagonal
   * @return if feld is not valid -1, else the token on on the feld
   */
  public int getValue(int row, int diagonal) {
    if(!isValid(row, diagonal)) {
      return -1;
    }
    return boardNodes[row][diagonal].getValue();
  }
  
  /**
   * Sets the board value for (row,diagonal) to value.
   * 
   * @param row
   * @param diagonal
   * @param value of the token
   */
  public void setValue(int row, int diagonal, int value) {
    boardNodes[row][diagonal].setValue(value);
  }
  
  /**
   * Returns the node at the position (row,diag).
   * 
   * @param row
   * @param diag
   * @return the Node on a feld
   */
  public HalmaBoardNode getNode(int row, int diag) {
    return boardNodes[row][diag];
  }
  
  /**
   * Returns a clone of the board.
   * ToDo: Nodes are not clone yet!
   * 
   * @return Clone of the board.
   */
  @Override
  public Object clone() {
      HalmaBoard newObject = new HalmaBoard();
      newObject.debug = this.debug;
      newObject.currentPlayer = this.currentPlayer;
      newObject.status = new Status(this.status.getValue());      
      for(int diagonal = 0; diagonal < 15; diagonal++) {
		    for(int row = 0; row < 11; row++) {
		    	newObject.boardNodes[row][diagonal] = (HalmaBoardNode)boardNodes[row][diagonal].clone();
		    }
      }
      return newObject;      
  }
  
  /**
   * Converts color-integer to String.
   * 
   * @param color Color-int (HalmaBoard.BLUE or HalmaBoard.RED)
   * @return String-representation of the color.
   */
  public static String colorToString(int color) {
    switch(color) {
      case BLUE:
        return "blue";
      case RED:
        return "red";
      default:
        return "unknown";
    }
  }
}
