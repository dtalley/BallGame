package src.game.gadget
{
  import src.game.gadget.Gadget;
  import src.game.utils.ConfigManager;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import src.game.Ball;
  
  public class Expand extends Gadget
  {
    private var m_base:Image;
    
    private var m_rotation:uint = 0;
    
    public function Expand(rotation:uint = 0) 
    {
      m_rotation = rotation;
      m_base = new Image(TextureManager.Get("atlas", "gadget_expand"));
      
      m_base.alignPivot();
      m_base.x = ConfigManager.TILE_SIZE / 2;
      m_base.y = ConfigManager.TILE_SIZE / 2;
      
      this.addChild(m_base);
      
      configure();
    }
    
    public override function tap():void
    {
      m_rotation += 1;
      if (m_rotation > 3)
      {
        m_rotation = 0;
      }
      configure();
    }
    
    public override function planTap():void
    {
      m_rotation += 1;
      if (m_rotation > 3)
      {
        m_rotation = 0;
      }
      configure();
    }
    
    private function configure():void
    {
      m_base.rotation = (Math.PI / 2) * m_rotation;
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      if ( percent == 1 )
      {
        if (ball.type >= 3)
        {
          var newBall:Ball = null;
          if (ball.type == Ball.PURPLE)
          {
            newBall = new Ball(Ball.RED);
            tile.board.addBall(newBall);
            newBall.tile = tile;
            ball.type = Ball.BLUE;
            
            if (m_rotation == 0)
            {
              newBall.direction.setTo(0, -1);
              ball.direction.setTo(0, 1);
            }
            else if (m_rotation == 1)
            {
              newBall.direction.setTo(1, 0);
              ball.direction.setTo(-1, 0);
            }
            else if (m_rotation == 2)
            {
              newBall.direction.setTo(0, 1);
              ball.direction.setTo(0, -1);
            }
            else
            {
              newBall.direction.setTo(-1, 0);
              ball.direction.setTo(1, 0);
            }
            
            newBall.calculateTarget();
            ball.calculateTarget();
          }
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
    
    public override function save():uint
    {
      return m_rotation;
    }
    
    public override function get id():uint
    {
      return GadgetManager.s_gadgets.indexOf(Expand);
    }
  }
}