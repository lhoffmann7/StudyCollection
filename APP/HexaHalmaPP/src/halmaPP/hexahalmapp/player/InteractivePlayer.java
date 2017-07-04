
package halmaPP.hexahalmapp.player;

import halmaPP.preset.Move;
import java.util.Scanner;

/**
 * Interactive Player. Asks the user for a move on the console.
 *
 * @author Stefan Peters
 */
public class InteractivePlayer extends AbstractPlayer {
  // Scanner for user-input
  Scanner scanner = new Scanner(System.in);
  
  /**
   * Asks the user for a move on the console.
   * 
   * @return Move of the user input.
   */
  @Override
  protected Move requestMove() {
    System.out.println("Insert move (row diagonal row diagonal ...):");
    Move move = null;
    boolean isOkay = false;
    while(!isOkay) {
      // Read user input
      String input = scanner.nextLine();
      move = null;      
      // Move not empty: interpretate move. Otherwise: player gives up (null).
      if(!input.equals("")) { 
        // split up string
        String delims = "[ ]+";
        String[] tokens = input.split(delims);
        // has to be an even number
        if(tokens.length%2 == 0) {
          Move lastMove = null, tempMove;
          int row, diag;
          for(int i = 0; i < tokens.length; i += 2) {
            row = Integer.parseInt(tokens[i]);
            diag = Integer.parseInt(tokens[i+1]);
            if(move != null) {
              // add following position
              tempMove = new Move(row,diag);
              lastMove.setNext(tempMove);
              lastMove = tempMove;
            } 
            else {
              // first position
              move = new Move(row,diag);
              lastMove = move;
            }          
          }
        }
        // move has to be valid, otherwise: repeat
        if(move != null && getBoard().isCorrect(move)) {
          isOkay = true;
        } else {
          System.out.println("Move was not valid! "
                  + "Try again: (row diagonal row diagonal ...)");
        }
      } else {
        System.out.println("Do you really want to give up? (yes/no)");
        input = scanner.nextLine();
        if(input.equals("yes")) {
          // giving up is okay, too
          isOkay = true;
        } else {
          // try again
          System.out.println("Okay, then try again: "
                  + "(row diagonal row diagonal ...)");
        }  
      }      
    }
    return move;
  }
  
}
