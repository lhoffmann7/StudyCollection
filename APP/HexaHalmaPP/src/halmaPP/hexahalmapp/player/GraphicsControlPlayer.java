
package halmaPP.hexahalmapp.player;

import halmaPP.preset.Move;

/**
 * Player which uses GraphicsPlayer's abilities to control the game with the mouse.
 * Only works when used with GraphicsPlayer! Otherwise, you will only get null-moves.
 *
 * @author Stefan Peters
 * @version 0.3
 */
public class GraphicsControlPlayer extends AbstractPlayer {
  private BoardPanel panel = null;
  
  @Override
  protected Move requestMove() {
    if(panel == null) {
      return null;
    }
    panel.waitForMove();
    
    return panel.getMove();
  }
  
  /**
   * Player needs access to the panel-reference so it can use the isMoveRead() and getMove() methods.
   * In a future version, this may be replaced by using Thread's wait and notify functionalities.
   * 
   * @param panel Panel-reference of the GraphicsPlayer which wraps around this.
   */
  public void setPanel(BoardPanel panel) {
    this.panel = panel;
  }
}
