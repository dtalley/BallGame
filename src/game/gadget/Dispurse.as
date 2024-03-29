package src.game.gadget 
{
  import src.game.Ball;
  import src.game.Tile;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	/**
   * ...
   * @author 
   */
  public class Dispurse extends Gadget 
  {
    private var m_base:Image;
    
    public function Dispurse(data:uint = 0) 
    {
      m_base = new Image(TextureManager.Get("game", "gadget_dispurse"));
      this.addChild(m_base);
    }
    
    public override function tap():void
    {
      
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      if ( percent != 1 )
      {
        return;
      }
      
      var current:Tile = ball.tile.top;
      while ( current )
      {
        current.modifyBalls(function(curball:Ball):void {
          curball.direction.x = 0;
          curball.direction.y = -1;
          curball.calculateTarget(false);
        });
        current = current.top;
      }
      
      current = ball.tile.left;
      while ( current )
      {
        current.modifyBalls(function(curball:Ball):void {
          curball.direction.x = -1;
          curball.direction.y = 0;
          curball.calculateTarget(false);
        });
        current = current.left;
      }
      
      current = ball.tile.right;
      while ( current )
      {
        current.modifyBalls(function(curball:Ball):void {
          curball.direction.x = 1;
          curball.direction.y = 0;
          curball.calculateTarget(false);
        });
        current = current.right;
      }
      
      current = ball.tile.bottom;
      while ( current )
      {
        current.modifyBalls(function(curball:Ball):void {
          curball.direction.x = 0;
          curball.direction.y = 1;
          curball.calculateTarget(false);
        });
        current = current.bottom;
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
      return GadgetManager.s_gadgets.indexOf(Dispurse);
    }
  }

}