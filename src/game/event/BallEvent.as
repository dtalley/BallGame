package src.game.event 
{
  import starling.events.Event;
  import src.game.Ball;
  import src.game.Tile;
  
  /**
   * ...
   * @author 
   */
  public class BallEvent extends Event 
  {
    private var m_tile:Tile;
    private var m_ball:Ball;
    
    public function BallEvent(type:String, ball:Ball, tile:Tile, bubbles:Boolean=false, cancelable:Boolean=false) 
    { 
      super(type, bubbles, cancelable);
      m_ball = ball;
      m_tile = tile;
    } 
    
    public function get tile():Tile
    {
      return m_tile;
    }
    
    public function get ball():Ball
    {
      return m_ball;
    }
    
    public static const BALL_CONSUMED:String = "orn_ballConsumed";
  }  
}