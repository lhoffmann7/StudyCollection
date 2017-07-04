package halmaPP.hexahalmapp;

/**
 * Class Position to differentiate between Move and Position on Board
 * @author Lukas Hoffmann
 *
 */
public class Position {
  public Position(int d, int r) //param-constructor
  {
    diagonal =d;
    row = r;
  }
  private int diagonal;
  private int row;
  
  //setter/getter
  public int getDiagonal()
  {
    return diagonal;
  }
  public int getRow()
  {
    return row;
  }
  
  /**
   * @param o Object
   * @return true, if Object instance and content are the same as the parameter Object
   */
  @Override
    public boolean equals(Object o)
    {
      if(this == o) //same Object?
        return true;
      if(o==null)
        return false;
      if(!(o instanceof Position)) 
        return false;
      Position p = (Position) o;
      return ((diagonal == p.getDiagonal()) && (row == p.getRow()));
      
    } 

  @Override
  public String toString()
  {
    return("<"+row + "," + diagonal + ">"); //Output form: <r/d>
  }
}