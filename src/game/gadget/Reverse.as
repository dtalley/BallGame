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
  public class Reverse extends Gadget 
  {
    private var m_base:Image;
    
    public function Reverse() 
    {
      m_base = new Image(TextureManager.Get("game", "gadget_reverse"));
      this.addChild(m_base);
      
      m_base.alignPivot();
      m_base.x = ConfigManager.TILE_SIZE / 2;
      m_base.y = ConfigManager.TILE_SIZE / 2;
    }
    
    public override function tap():void
    {
      
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      if ( percent == 1 )
      {
        ball.direction.x *= -1;
        ball.direction.y *= -1;
      }
    }
    
    public override function reset():void
    {
      
    }
    
    public override function get isMoveable():Boolean
    {
      return true;
    }
    
    public override function get isRemoveable():Boolean
    {
      return true;
    }
    
    public override function get id():uint
    {
      return GadgetManager.s_gadgets.indexOf(Reverse);
    }
  }

}