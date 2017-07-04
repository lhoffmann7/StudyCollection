
package halmaPP.hexahalmapp;

/**
 * Node-class for internal board organization in the HalmaBoard.
 * Adds extended functionalities over a simple int-Array.
 *
 * @author Stefan Peters
 * @version 0.3
 */
public class HalmaBoardNode {  
  private HalmaBoardNodeType type;
  private int value;
  
  /**
   * Constructor. No need of parameters. Standard-initialization is:
   * value = free
   * type = standard
   * 
   */
  public HalmaBoardNode() {
    value = HalmaBoard.FREE;
    type = HalmaBoardNodeType.Standard;
  }
  
  /**
   * Sets the node-value.
   * 
   * @param value Node-value
   */
  public void setValue(int value) {
    this.value = value;
  }
  
  /**
   * Returns the node-value.
   * 
   * @return Node-value
   */
  public int getValue() {
    return value;
  }
  
  /**
   * Sets the node-type.
   * 
   * @param type Node-type
   */
  public void setType(HalmaBoardNodeType type) {
    this.type = type;
  }
  
  /**
   * Returns the node-type.
   * 
   * @return Node-type.
   */
  public HalmaBoardNodeType getType() {
    return type;
  }
  
  @Override
  public Object clone() {
    HalmaBoardNode clone = new HalmaBoardNode();
    clone.setType(type);
    clone.setValue(value);
    return clone;
  }
}
