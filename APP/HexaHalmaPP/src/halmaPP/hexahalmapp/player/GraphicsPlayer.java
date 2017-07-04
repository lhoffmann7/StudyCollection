
package halmaPP.hexahalmapp.player;

import halmaPP.hexahalmapp.HalmaBoard;
import halmaPP.preset.Move;
import halmaPP.preset.Player;
import halmaPP.preset.Status;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.geom.Line2D;
import java.rmi.RemoteException;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 * Wrapper class for any player who extends AbstractPlayer which shows
 * the player's board in a window.
 *
 * @author Stefan Peters
 * @version 0.7
 */
public class GraphicsPlayer implements Player {
  private Player player;
  private BoardPanel panel;
  private static int number = 1;
  private JFrame frame;
  /**
   * Constructor creates the window with a BoardPanel for the player.
   * 
   * @param player Reference to the player whose board we want to display
   */
  public GraphicsPlayer(AbstractPlayer player) {
    this.player = player;
    // Create new frame
    frame = new JFrame(player.getClass().getName()+" - Player "+number++);
    frame.setMinimumSize(new Dimension(360,259));
    // Create new panel and add it to the frame
    panel = new BoardPanel(player.getBoard());
    frame.add(panel);
    // pack the frame and show it
    frame.pack();    
    frame.validate();
    frame.setVisible(true);    
    
    // settings, if player is a GraphicsControlPlayer
    if(player instanceof GraphicsControlPlayer) {
      ((GraphicsControlPlayer)player).setPanel(panel);
      // MouseListener only needed for GraphicsControlPlayer
      panel.addMouseListener();
    }
    panel.addMouseMotionListener();    
  }
  
  /**
   * Returns the player-reference.
   * Is needed when access to AbstractPlayer's features are needed.
   * In a future version, all methods of AbstractPlayer might be implemented in this player, so this method is not needed anymore.
   * 
   * @return Returns the encapsulated player
   */
  public Player getPlayer()
  {
	  return player;
  }
  
  /**
   * Link to AbstractPlayer's request
   * 
   * @return Requested move
   * @throws Exception
   * @throws RemoteException
   * @see AbstractPlayer
   */
  @Override
  public Move request() throws Exception, RemoteException {
    return player.request(); 
  }

  /**
   * Link to AbstractPlayer's confirm
   * Since a confirm could update the player's board, the panel is repainted
   * 
   * @param boardStatus
   * @throws Exception
   * @throws RemoteException 
   * @see AbstractPlayer
   */
  @Override
  public void confirm(Status boardStatus) throws Exception, RemoteException {
    player.confirm(boardStatus);
    panel.repaint();
    
  }

  /**
   * Link to AbstractPlayer's update
   * Since an update comes with a change of the board, the panel is repainted
   * 
   * @param opponentMove
   * @param boardStatus
   * @throws Exception
   * @throws RemoteException 
   * @see AbstractPlayer
   */
  @Override
  public void update(Move opponentMove, Status boardStatus) throws Exception, RemoteException {
    player.update(opponentMove, boardStatus);
    panel.repaint();
  }
}


/**
 * Creates a panel which shows a HalmaBoard.
 * Also has features for mouse-control of the board which are used by GraphicsControlPlayer.
 * 
 * @author Stefan Peters
 * @version 0.5
 */
class BoardPanel extends JPanel implements MouseListener, MouseMotionListener {
  private static final long serialVersionUID = 1L;
  // constants used in calculations
  private static final double POLWIDTHDIVISOR = 3.43;
  private static final double HEIGHTFACTOR = 10.3;
  private static final double WIDTHFACTOR = 15.5;
  // start-dimensions of the panel
  private static final int STARTHEIGHT = 396;
  private static final int STARTWIDTH = 600;
  
  private static final int STARTPOLWIDTH = 32;
  // colors
  private static final Color REDGOALCOLOR = new Color(250,179,179);
  private static final Color BLUEGOALCOLOR = new Color(179,179,250);
  private static final Color BLUESTARTCOLOR = new Color(220,220,255);
  private static final Color MIXEDGOALCOLOR = new Color(215,140,215);
  private static final Color REDSTARTCOLOR = new Color(255,220,220);
  // this value actually represents the horizontal distance from one polygon to the next polygon in one row.
  // will be changed whenever the window is resized.
  private int polWidth;
  // the top and left offset value.
  private int offset = polWidth/2;
  // Array of all polygons.
  private Polygon[][] polygons;
  // Reference to the player's board
  private HalmaBoard board;
  // Coordinates of the bottom-left point where to painting of the polygons begins. 
  private int xStart, yStart;
  // labels for mouse-over position display (top left) and player-type display (bottom left)
  private String lblPosition = "";
  // current move for mouse-control
  private Move move = null;
  // will be true when player has finished choosing his move.
  private boolean isMoveReady = false;
  // reference to the GraphicsPlayer's frame (to be able to close it)
  private final Object lock = new Object();
  
  /**
   * Constructor needs player's board.
   * 
   * @param board Reference on the player's board
   */
  public BoardPanel(HalmaBoard board) {
    super();
    this.setBackground(Color.white);
    this.board = board;
    // initialize array of polygons
    polygons = new Polygon[11][15];
    polWidth = STARTPOLWIDTH;
  }
  
  /**
   * Because the mouseListener is not always needed, it may be added afterwards.
   * 
   */
  public void addMouseListener() {
    addMouseListener(this);
  }
  
  /**
   * Because the mouseMotionListener is not always needed, it may be added afterwards.
   * 
   */
  public void addMouseMotionListener() {
    addMouseMotionListener(this);
  }
  
  @Override
  public Dimension getPreferredSize() {    
    // panel initialization with a width of 600 px
    return new Dimension(STARTWIDTH, STARTHEIGHT);
  }

  @Override
  protected void paintComponent(Graphics g) {
    super.paintComponent(g);    
    // computes polWith by using the window-size
    int w = (int)(this.getSize().width/WIDTHFACTOR);
    int h = (int)(this.getSize().height/HEIGHTFACTOR);
    if(h > w) {
      polWidth = w;            
    } else {
      polWidth = h;      
    }
    offset = polWidth/2; 
    // Graphics2D with anti-aliasing for better looks
    Graphics2D g2d = (Graphics2D)g;
    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    
    // go through the board and paint all fields as polygons
    for(int row = 0; row < 11; row++) {        
      for(int diag = 0; diag < 15; diag++) {
        // Checks, if (row,diag) is a valid field
        if(board.getValue(row, diag) != HalmaBoard.INVALID) {
          // getPolygon computes and returns the needed polygon
          Polygon pol = getPolygon(row, diag);
          // add polygon to the array for use in mouseClicked
          polygons[row][diag] = pol;
          // determine the polygon's color
          g2d.setColor(Color.LIGHT_GRAY);
          switch(board.getNode(row, diag).getType()) {
            case RedStart:
              g2d.setColor(REDSTARTCOLOR);
              break;
            case RedGoal:
              g2d.setColor(REDGOALCOLOR);
              break;
            case BlueStart:
              g2d.setColor(BLUESTARTCOLOR);
              break;
            case BlueGoal:
              g2d.setColor(BLUEGOALCOLOR);
              break;
            case MixedGoal:
              g2d.setColor(MIXEDGOALCOLOR);
            default:
              // do nothing  
          }
          // color of the figures
          switch(board.getValue(row, diag)) {
            case HalmaBoard.BLUE:
              g2d.setColor(Color.BLUE);
              break;
            case HalmaBoard.RED:
              g2d.setColor(Color.RED);
              break;
          }
          // fill the polygon and draw the outline
          if(isInCurrentMove(row, diag)) {
            g2d.setColor(g2d.getColor().darker().darker());
          }
          g2d.fillPolygon(pol);
          switch(board.getNode(row, diag).getType()) {
            case RedGoal:
              g2d.setColor(Color.RED);
              break;
            case BlueGoal:
              g2d.setColor(Color.BLUE);
              break;
            case MixedGoal:
              g2d.setColor(Color.MAGENTA);
              break;
            default:
              g2d.setColor(Color.BLACK);
              break;
          }
          g2d.drawPolygon(pol);
          // draw the lines between the polygons
          g2d.setColor(Color.BLACK);
          Line2D.Float[] lines = getLines(row, diag);
          for(int k = 0; k < 3; k++) {
            if(lines[k] != null) {
              g2d.draw(lines[k]);
            }
          }
        }
      }
    }
    // draw the two labels
    g2d.drawString(lblPosition, 5, 15);
  }

  private int computeX(int row, int diag) {
    return 2*polWidth+diag*polWidth-polWidth/2*row + offset;
  }

  private int computeY(int row) {
    return (int)((10-row)*polWidth*0.875)+ offset;
  }
  
  /**
   * Determines if (row,diag) is already in the current move.
   * Only needed for displaying the current move
   * 
   * @param row
   * @param diag
   * @return true,position was visited before
   */
  private boolean isInCurrentMove(int row, int diag) {
    Move m = move;
    while(m != null) {
      if(m.getDiagonal() == diag && m.getRow() == row) {
        return true;
      }
      m = m.getNext();
    }
    return false;
  }
  
  /**
   * Computes and returns the polygon of the field (row,diag).
   * 
   * @param row
   * @param diag
   * @return Polygon at field (row,diag).
   */
  private Polygon getPolygon(int row, int diag) {
    Polygon pol = new Polygon();
    // compute x position on the panel
    int x = computeX(row, diag);
    // compute y position on the panel
    int y = computeY(row);
    
    // setting sStart and yStart for the (0,0) field.
    if(row == 0 && diag == 0) {
      xStart = x;
      yStart = y+2*(int)(polWidth/POLWIDTHDIVISOR);
    }
    // build the polygon
    pol.addPoint(x+ 0,y+(int)(polWidth/POLWIDTHDIVISOR));
    pol.addPoint(x+ polWidth/6,y+ 0);
    pol.addPoint(x+polWidth/2,y+ 0);
    pol.addPoint(x+(int)(polWidth/1.5),y+(int)(polWidth/POLWIDTHDIVISOR));
    pol.addPoint(x+polWidth/2,y+(int)(polWidth/POLWIDTHDIVISOR*2));
    pol.addPoint(x+ polWidth/6,y+(int)(polWidth/POLWIDTHDIVISOR*2));
    return pol;
  }
  
  /**
   * Returns an array of lines around the polygon at field (row,diag).
   * 
   * @param row
   * @param diag
   * @return lines
   */
  private Line2D.Float[] getLines(int row, int diag) {
    // compute x position on the panel
    int x = computeX(row, diag);
    // compute y position on the panel
    int y = computeY(row);
    
    // only three lines are necessary
    Line2D.Float[] lines = new Line2D.Float[3];
    // left
    if(board.isValid(row, diag-1)) {
      lines[0] = new Line2D.Float(x+ 0,y+(int)(polWidth/POLWIDTHDIVISOR),
                          x-polWidth/3,y+(int)(polWidth/POLWIDTHDIVISOR));
    }
    // top-left
    if(board.isValid(row+1, diag)) {
      lines[1] = new Line2D.Float(x+ polWidth/6,y+ 0, 
                                  x+0,y-(int)(polWidth/POLWIDTHDIVISOR));
    }
    // top-right
    if(board.isValid(row+1, diag+1)) {
      lines[2] = new Line2D.Float(x+polWidth/2,y+ 0, 
                    x+ (int)(polWidth/1.5),y-(int)(polWidth/POLWIDTHDIVISOR));
    }
    return lines;
  }

  /**
   * Core functionality for mouse-control of the game.
   * 
   * @param me 
   */
  @Override
  public void mouseClicked(MouseEvent me) { 
    if(!isMoveReady) {
      // user finishes move by a double click
      if(me.getClickCount()>1) {
    	  synchronized (lock) {
    		isMoveReady = true;
          // notify locked GraphicsControlPlayer's request method
        	lock.notifyAll();			
    	  }
      }   
      // getPositions computes the current field (row,diag) for the mouse-position.
      int[] positions = getPositions(me);
      int row = positions[0];
      int diag = positions[1];
      if(move == null) {
        // does not accept a move that doesn't start at the current player
    	  // isValid
        if(row > 10 || diag > 14 || board.getValue(row, diag) != board.getCurrentPlayer()) return;
        move = new Move(row, diag);
      } else {
        Move m = move;
        while(m.getNext() != null) m = m.getNext();
        // only accept move if the destination-field is free and not already in the current move.
        // ToDo: Check whole move and only accept valid moves!
        m.setNext(new Move(row, diag));
        if(board.isCorrect(move)) {
          repaint();
        } else {
          m.setNext(null);
        }   
        }          
      }         
    }

  @Override
  public void mousePressed(MouseEvent me) { }

  @Override
  public void mouseReleased(MouseEvent me) { }

  @Override
  public void mouseEntered(MouseEvent me) { }

  @Override
  public void mouseExited(MouseEvent me) { }

  @Override
  public void mouseDragged(MouseEvent me) { }

  /**
   * Gives us the mouse-over display of the fields' positions.
   * 
   * @param me 
   */
  @Override
  public void mouseMoved(MouseEvent me) {
    int[] positions = getPositions(me);
    int row = positions[0];
    int diag = positions[1];
    String labelnew = "";
    if(board.isValid(row, diag)) {
      if(polygons[row][diag].contains(me.getX(), me.getY())) {
        labelnew = row+" "+diag;        
      }
    }
    if(!labelnew.equals(lblPosition))
      repaint();
    lblPosition = labelnew;
  }
  
  /**
   * Computes the field-position in relation to the mouse-position.
   * 
   * @param me MouseEvent
   * @return Two dimenstional array of field-positions
   */
  private int[] getPositions(MouseEvent me) {
    int x = me.getX();
    int y = me.getY();
    int h = (int)(polWidth*0.875);    
    int yn = (yStart-y)/h;
    int xn = xStart-polWidth/2*yn;
    xn = (x-xn)/polWidth;
    return new int[] {yn, xn};
  }
  
  /**
   * Returns the move for the mouse-control.
   * Returns null if user has not finished yet.
   * 
   * @return move or null
   */
  public Move getMove() {
    if(isMoveReady) {
      Move m = move;
      move = null;
      isMoveReady = false;
      if(m == null) {
        // Player is giving up, but my be unintentional, so better ask him about it
        JFrame f = new JFrame();        
        int n = JOptionPane.showConfirmDialog(f, "Would you really like to give up?", "Giving up already?", JOptionPane.YES_NO_OPTION);
        if(n==1) {
          m = new Move(0,0);
        }
      }      
      return m;
    } else {
      return null;
    }
  } 
  
  /**
   * Only use getMove() method after this method returned true.
   * 
   * 
   */
  public void waitForMove() {
    synchronized (lock) {
		while(!isMoveReady) {
			try {
        // let the request-method wait for the user to finish the move
				lock.wait();
			} catch (InterruptedException e) {
				// no interruption please!
			}
		}
	}
  }
}