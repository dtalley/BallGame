package src.game.gadget 
{
  import src.game.Ball;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	/**
   * ...
   * @author 
   */
  public class Dispurse extends Gadget 
  {
    private var m_base:Image;
    
    public function Dispurse() 
    {
      m_base = new Image(TextureManager.Get("atlas", "gadget_dispurse"));
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
      
      if ( ball.tile.top )
      {
        ball.tile.top.modifyBalls(function(curball:Ball):void {
          curball.direction.x = 0;
          curball.direction.y = -1;
          curball.calculateTarget();
        });
      }
      
      if ( ball.tile.left )
      {
        ball.tile.left.modifyBalls(function(curball:Ball):void {
          curball.direction.x = -1;
          curball.direction.y = 0;
          curball.calculateTarget();
        });
      }
      
      if ( ball.tile.right )
      {
        ball.tile.right.modifyBalls(function(curball:Ball):void {
          curball.direction.x = 1;
          curball.direction.y = 0;
          curball.calculateTarget();
        });
      }
      
      if ( ball.tile.bottom )
      {
        ball.tile.bottom.modifyBalls(function(curball:Ball):void {
          curball.direction.x = 0;
          curball.direction.y = 1;
          curball.calculateTarget();
        });
      }
    }
    
    public override function reset():void
    {
      
    }
  }

}