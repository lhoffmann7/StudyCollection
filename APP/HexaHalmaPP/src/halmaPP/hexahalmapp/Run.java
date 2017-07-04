package halmaPP.hexahalmapp;
import halmaPP.hexahalmapp.player.*;
import halmaPP.preset.Move;
import halmaPP.preset.Player;
import halmaPP.preset.Status;
import java.io.IOException;
import java.rmi.RemoteException;
import java.util.Scanner;

/**
 * Executable Class to control and handle the game and players.
 * @author Lukas Hoffmann
 * @version 1.0
 */
public class Run {
	
	//Commandline Arguments
	private static final String HUMAN = "human";
	private static final String MEDIUMCPU = "medium";
	private static final String EASYCPU = "easy";
	private static final String MILLIS = "-m";
	private static final String CONSOLE = "-c";
	private static final String PRESSKEY = "-pk";
	private static final String DEBUG = "-d";
	private static final String MOUSE = "mouse";

	private boolean debug =false;
	private boolean presskey = false;
	private boolean graphics = true;
	private HalmaBoard controlBoard = new HalmaBoard();
	private Scanner scanner = new Scanner(System.in);
	private int millis = 500; //standard delay in KI game = 500 milliseconds
	
	/**
	 * Creates two players according to the arguments and starts the game.
	 * @param  args easy, medium, human, mouse, -m x, -c, -d, -pk
	 */
	public static void main(String[] args) throws RemoteException, Exception {
		
		Run run = new Run(); //create run object to use non-static methods
      
		if(args.length <2) //minimum 2 arguments (2 players)
		{
			run.help();
			System.exit(0);
		}
		else
		{
			for(int i=2;i<args.length;i++)
			{
				String a = args[i];
				if(a.equals(DEBUG)) //debug flag
				{
					run.debug = true;
					run.controlBoard.setDebug(true); //set debug printouts in HalmaBoard 
				} else if(a.equals(PRESSKEY)) //presskey flag
				{
					run.presskey = true;
				} else if(a.equals(CONSOLE)) //console play flag
				{
					if(args[0].equals(MOUSE) || args[1].equals(MOUSE)) { //mouse-player needs graphics
						System.out.println("You can't turn off graphics when using the mouse.");
						run.help();
						return;
					}
					run.graphics = false;
				} else if(a.equals(MILLIS) && i+1<args.length) //control KI game speed flag
				{
					try 
					{
						run.millis = Integer.parseInt(args[i+1]); //parse next argument (milliseconds)
					} catch(NumberFormatException e) { //help if entered wrong number format
						run.help();
						return;
					}
					i++; //skip next argument because of parsing
				} else {
					run.help();
					return;
				}
			}
			try{
				//Start game with 2 players according to first and second argument
				run.startGame(run.getPlayer(args[0]),run.getPlayer(args[1])); 
				//end game, windows closed
			}
			catch(IOException e){
				run.help();
			}
			
		}
    System.out.println("Press ENTER to end the game.");
    run.scanner.nextLine();
    // close all the frames and the game itself
		System.exit(0);
	}	
	/**
	 * Handles run of play with alternate moves of the players.
	 * @param p1 Player 1
	 * @param p2 Player 2
	 * @throws RemoteException
	 * @throws Exception
	 * 
	 */
	private void startGame(Player p1, Player p2) 
	throws RemoteException, Exception
	{
		if(debug)
			System.out.println(controlBoard);
		System.out.println("Press ENTER to start the game.");
		scanner.nextLine();
		while(true)
		{
			boolean end;
			end = playerMove(p1, p2); //player 1 move
			if(debug && !end)
			{
				System.out.println("ControlBoard:");
				System.out.println(controlBoard);
			}
			if(presskey)
				scanner.nextLine();
			else
				waitFor(millis);
			if(end) //if end condition is true, finish the game
				return;
			//Player switch
			Player tmp = p1;
			p1 = p2;
			p2 = tmp;
			
		}
	}
	
	/**
	 * Uses methods from the AbstractPlayer to handle the moves and boards of the players.
	 * @param current Player
	 * @param opponent Player
	 * @return true, if game is finished
	 * @throws RemoteException
	 * @throws Exception
	 * 
	 */
	private boolean playerMove(Player current, Player opponent)throws RemoteException, Exception
	{
	
		Status boardStatus = new Status(Status.OK);
		Move move = null;
		boolean end;
		do{
			move = current.request(); //first request current player
			
			if(debug) //debug output: players turn
			{
				System.out.println("turn " + HalmaBoard.colorToString(controlBoard.getCurrentPlayer()));
				System.out.println(move);	
			}
			boardStatus = controlBoard.setMove(move);  
			current.confirm(boardStatus); //then confirm current player
		} while(boardStatus.getValue() == Status.ILLEGAL); //repeat requesting as long as move is illegal

		opponent.update(move, boardStatus); //...and update board of the opponent player
		end = handleTurn(boardStatus);
		return end;

	}
	
	/**
	 * Getter-Method to create the different types of players.
	 * @param s String from command line
	 * @return Player-Object according to the input String
	 * @throws IOException if String is an invalid command line argument to set player
	 */
	private Player getPlayer(String s) throws IOException
	{
    AbstractPlayer player;
		if(s.equals(EASYCPU))	
			player = new EasyCPU();
		else if(s.equals(MEDIUMCPU))	
			player = new MediumCPU(); 
		else if(s.equals(HUMAN))	
			player = new InteractivePlayer();
		else if(s.equals(MOUSE))
			player = new GraphicsControlPlayer();
		else
			throw new IOException("Wrong input String");
    if(graphics) {
    	return new GraphicsPlayer(player); //if graphics controlled play is wished, consign player to GraphicsPlayer 
    } else {
    	return player;
    }
	}
	
	/**
	 * Handles status of the board.
	 * @param boardStatus
	 * @return true, by winning or draw condition 
	 * @throws Exception if Status= ERROR or Status is invalid
	 */
	private boolean handleTurn(Status boardStatus) throws Exception
	{
		switch(boardStatus.getValue()) //5 different Status-Types
		{
			case Status.OK:
			{
				//do nothing
				return false;
			}
			case Status.REDWIN:
			{	
				if(debug)
				{
					System.out.println("Result:");
					System.out.println(controlBoard);
				}
					
				System.out.println("Red Player wins!");
				return true; //game ends
			}
			case Status.BLUEWIN:
			{
				if(debug)
				{
					System.out.println("Result:");
					System.out.println(controlBoard);
				}
				System.out.println("Blue Player wins!");
				return true;
			}
			case Status.DRAW:
			{
				if(debug)
				{
					System.out.println("Result:");
					System.out.println(controlBoard);
				}
				System.out.println("Draw!");
				return true;
			}
			case Status.ERROR:
				throw new Exception("ERROR");
			default:
				throw new IllegalArgumentException("ERROR");
		}
		
	}

	/**
	 * Service Method: Displays the right command line arguments. 
	 */
	
	private void help()
	{
		System.out.println("Please insert Arguments this way: "+ "\n" +
				"First Argument:" + "\n" + 	"easy: \t Computer-Player Easy "+ "\n" +
								"medium:\t Computer-Player Medium" + "\n" +
								"human: \t Interactive Player \n" + "mouse: \t Graphics-Controlled-Player");
		System.out.println("Second Argument (play against):" + "\n" + "easy: \t Computer-Player Easy "+ "\n" +
					"medium:  Computer-Player Medium" + "\n" +
					"human: \t Interactive Player" + "\n" + "mouse: \t Graphics-Controlled-Player");
		System.out.println("Additional Arguments:" + "\n" + "-pk (press key): Press any key to see next KI move "+ "\n" +
				"-m <x>: \t Set delay to x milliseconds in KI game \n-c: \t \t Console-Play with no graphics output");
	}
	
	
	/**
	 * Let the Thread sleep for x milliseconds.
	 * @param millis ,milliseconds
	 */
	private void waitFor(long millis) {
        try {
            Thread.sleep(millis);
        }
        catch (InterruptedException e) {
        }
    }
}



