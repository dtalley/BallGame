package src.game.gadget
{
  import src.game.gadget.Gadget;
  import src.game.Tile;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import src.game.Ball;
  
  public class Combine extends Gadget
  {
    private var m_base:Image;
    
    public function Combine() 
    {
      m_base = new Image(TextureManager.Get("atlas", "gadget_combine"));
      this.addChild(m_base);
    }
    
    public override function tap():void
    {
      
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      if ( percent == 1 )
      {
        var balls:Vector.<Ball> = new Vector.<Ball>();
        balls.push(ball);
        
        var current:Tile = ball.tile.left;
        if ( current )
        {
          current.modifyBalls(function(curball:Ball):void {
            balls.push(curball);
          });
        }
        
        current = ball.tile.top;
        if ( current )
        {
          current.modifyBalls(function(curball:Ball):void {
            balls.push(curball);
          });
        }
        
        current = ball.tile.right;
        if ( current )
        {
          current.modifyBalls(function(curball:Ball):void {
            balls.push(curball);
          });
        }
        
        current = ball.tile.left;
        if ( current )
        {
          current.modifyBalls(function(curball:Ball):void {
            balls.push(curball);
          });
        }
        
        if ( balls.length == 2 )
        {
          if ( balls[0].type != Ball.PURPLE && balls[1].type != Ball.PURPLE && balls[0].type != balls[1].type )
          {
            balls[1].removeFromTile();
            ball.type = Ball.PURPLE;
          }
        }
        else if ( balls.length > 2 )
        {
          //TODO - EXPLODE!!!!
        }
      }
    }
    
    public override function permit(ball:Ball):void
    {
      
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
      return GadgetManager.s_gadgets.indexOf(Combine);
    }
  }
}