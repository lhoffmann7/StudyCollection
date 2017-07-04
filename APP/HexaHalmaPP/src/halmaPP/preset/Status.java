package halmaPP.preset;

/**
 * Status-class for the board-status.
 * 
 */
public class Status implements java.io.Serializable {
    // declaration of the constants
    public static final int OK       = 0;
    public static final int REDWIN   = 1;
    public static final int BLUEWIN  = 2;
    public static final int DRAW     = 3;
    public static final int ILLEGAL  = 9;
    public static final int ERROR    = 99;

    /**
     * Contructor expects one of the Status-constants.
     * 
     * @param value Value of the status.
     */
    public Status(int value) { 
        this.value = value; 
    }

    /**
     * Is the value of the status Status.OK?
     * 
     * @return True if value is Status.OK
     */
    public boolean isOK() { 
        return value == OK;
    }

    /**
     * Is the value of the status Status.REDWIN?
     * 
     * @return True if value is Status.REDWIN
     */
    public boolean isREDWIN() {
        return value == REDWIN;
    }

    /**
     * Is the value of the status Status.BLUEWIN?
     * 
     * @return True if value is Status.BLUEWIN
     */
    public boolean isBLUEWIN() {
        return value == BLUEWIN;
    }
    
    /**
     * Is the value of the status Status.DRAW?
     * 
     * @return True if value is Status.DRAW
     */
    public boolean isDRAW() {
        return value == DRAW;
    }

    /**
     * Is the value of the status Status.ILLEGAL?
     * 
     * @return True if value is Status.ILLEGAL
     */
    public boolean isILLEGAL() {
        return value == ILLEGAL;
    }

    /**
     * Is the value of the status Status.ERROR?
     * 
     * @return True if value is Status.ERROR
     */
    public boolean isERROR() {
        return value == ERROR;
    }

    /**
     * Returns the value of the status.
     * 
     * @return Value of the status.
     */
    public int getValue () {
       return value ;
    }

    /**
     * Sets the value of the status.
     * 
     * @param value Value of the status
     */
    public void setValue (int value) {
        this.value = value ;
    }

    /**
     * Returns a string-representation of the status.
     * 
     * @return String-representation of the status
     */
    public String toString() {
	String s = "";

	switch (value) { 
	case OK: 
	    s = "ok";
	    break;
	case REDWIN:
	    s = "red wins";
	    break;
	case BLUEWIN:
	    s = "blue wins";
	    break;
	case DRAW: 
	    s = "draw";
	    break;
	case ILLEGAL: 
	    s = "illegal";
	    break;
	case ERROR:
	default:
	    s = "error";
	}

	return s;
    }


    // private -------------------------------------------------------
    private static final long serialVersionUID = 1L;
    private int value = OK;
}
