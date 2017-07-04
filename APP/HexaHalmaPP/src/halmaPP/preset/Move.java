package halmaPP.preset;

/**
 * Move-class. Encapsulates a move (which can contain unlimited steps).
 * 
 */
public class Move implements java.io.Serializable {
  /**
   * Constructor expects a start position (row,diagonal).
   * 
   * @param row
   * @param diagonal 
   */
    public Move(int row, int diagonal) {
	this.row = row;
	this.diagonal = diagonal;
	next = null;
    }

    /**
     * Alternative constructor expects a start position (row,diagonal) and a following move.
     * 
     * @param row
     * @param diagonal
     * @param next 
     */
    public Move(int row, int diagonal, Move next) {
	this.row = row;
	this.diagonal = diagonal;
	this.next = next;
    }

    /**
     * Alternative constructor expects a move which is copied.
     * @param mov 
     */
    public Move(Move mov) {
	row = mov.getRow();
	diagonal = mov.getDiagonal();
	next = mov.getNext();
    }

    /**
     * Returns the row-value of the move.
     * 
     * @return Row-value of the move.
     */
    public int getRow() {
	return row;
    }
    
    /**
     * Returns the diagonal-value of the move.
     * 
     * @return diagonal-value of the move.
     */    
    public int getDiagonal() {
	return diagonal;
    }

    /**
     * Returns the move that follows the current move.
     * 
     * @return Move that follows the current move.
     */
    public Move getNext() {
	return next;
    }

    /**
     * Sets the following move.
     * 
     * @param next Following move.
     */
    public void setNext(Move next) {
	this.next = next;
    }

    /**
     * Returns a string-representation in the form (r,d),(r,d),...
     * 
     * @return String-representation of the move.
     */
    public String toString() {
	String s = "(" + row + "/" + diagonal + ")";
	if (next == null)
	    return s;

	return s + "," + next;
    }

    // private ------------------------------------------------------
    private static final long serialVersionUID = 1L;
    private Move next = null;
    private int row;
    private int diagonal;
}
