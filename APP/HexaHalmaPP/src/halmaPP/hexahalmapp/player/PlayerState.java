
package halmaPP.hexahalmapp.player;

/**
 * Describes the state of an AbstractPlayer.
 * Start = Player was just initialized. Request and Update are possible.
 * Request = Player expects a request. No other call is possible.
 * Confirm = Player expects a confirm. No other call is possible.
 * Update = Player expects a request. No other call is possible.
 * End = Game has ended.
 *
 * @author Stefan Peters
 * @version 1.0
 */
public enum PlayerState {
  Start, Request, Confirm, Update, End
}
