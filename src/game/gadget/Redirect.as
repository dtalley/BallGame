package src.game.gadget 
{
  import src.game.Ball;
  import src.game.Board;
  import src.game.utils.ConfigManager;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	/**
   * ...
   * @author 
   */
  public class Redirect extends Gadget 
  {
    private var m_base:Image;
    
    public function Redirect() 
    {
      m_base = new Image(TextureManager.Get("atlas", "gadget_redirect"));
      this.addChild(m_base);
      
      m_base.alignPivot();
      m_base.x = ConfigManager.TILE_SIZE / 2;
      m_base.y = ConfigManager.TILE_SIZE / 2;
    }
    
    public override function tap():void
    {
      m_base.rotation += Math.PI / 2;
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      if ( m_base.rotation == 0 )
      {
        ball.direction.x = 1;
        ball.direction.y = 0;
      }
      else if ( m_base.rotation == Math.PI / 2 )
      {
        ball.direction.x = 0;
        ball.direction.y = 1;
      }
      else if ( m_base.rotation == Math.PI )
      {
        ball.direction.x = -1;
        ball.direction.y = 0;
      }
      else if ( m_base.rotation == Math.PI / -2 )
      {
        ball.direction.x = 0;
        ball.direction.y = -1;
      }
    }
    
    public override function reset():void
    {
      
    }
    
    public override function get isMoveable():Boolean
    {
      return true;
    }
    
    public override function get id():uint
    {
      return GadgetManager.s_gadgets.indexOf(Redirect);
    }
  }

}