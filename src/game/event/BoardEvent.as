package src.game.event 
{
  import starling.events.Event;
  
  /**
   * ...
   * @author 
   */
  public class BoardEvent extends Event 
  {
    public function BoardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
    { 
      super(type, bubbles, cancelable);
    }
    
    public static const BOARD_COMPLETE:String = "orn_boardComplete";
  }
  
}