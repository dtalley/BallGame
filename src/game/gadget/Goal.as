package src.game.gadget
{
  import flash.events.Event;
  import src.game.event.BallEvent;
  import src.game.gadget.Gadget;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import src.game.Ball;
  
  public class Goal extends Gadget
  {
    private var m_base:Image;
    private var m_indicator:Image;
    
    private var m_type:uint;
    private var m_target:uint = 1;
    private var m_consumed:uint = 0;
    
    public function Goal(data:uint = 0x00000009) //Target = 1, type = 1 
    {
      m_type = data & 0x7;
      m_target = ( data >> 3 ) & 0xF;
      if (m_target == 0)
      {
        m_target = 1;
      }
      configure();
      this.addChild(m_base);
      this.addChild(m_indicator);
    }
    
    private function configure():void
    {
      if (!m_base)
      {
        m_base = new Image(TextureManager.Get("game", "gadget_goal_red"));
      }
      
      if (!m_indicator)
      {
        m_indicator = new Image(TextureManager.Get("game", "goal_t" + m_target + "_c" + m_consumed));
      }
      
      m_indicator.texture = TextureManager.Get("game", "goal_t" + m_target + "_c" + m_consumed);
      
      if ( m_type == Ball.PURPLE )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_purple");
      }
      else if ( m_type == Ball.BLUE )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_blue");
      }
      else if ( m_type == Ball.RED )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_red");
      }
      else if ( m_type == Ball.GREEN )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_green");
      }
      else if ( m_type == Ball.YELLOW )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_yellow");
      }
      else if ( m_type == Ball.CYAN )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_cyan");
      }
      else if ( m_type == Ball.WHITE )
      {
        m_base.texture = TextureManager.Get("game", "gadget_goal_gray");
      }
    }
    
    public function set type(val:uint):void
    {
      m_type = val;
      configure();
    }
    
    public function get type():uint
    {
      return m_type;
    }
    
    public override function tap():void
    {
      if ( m_type == Ball.RED )
      {
        if (m_target == 1)
        {
          m_target = 2;
        }
        else
        {
          m_target = 1;
          this.type = Ball.BLUE;
        }
      }
      else if ( m_type == Ball.BLUE )
      {
        if (m_target == 1)
        {
          m_target = 2;
        }
        else
        {
          m_target = 1;
          this.type = Ball.PURPLE;
        }
      }
      /*else if ( m_type == Ball.BLUE )
      {
        this.type = Ball.PURPLE;
      }
      else if ( m_type == Ball.PURPLE )
      {
        this.type = Ball.YELLOW;
      }
      else if ( m_type == Ball.YELLOW )
      {
        this.type = Ball.CYAN;
      }
      else if ( m_type == Ball.CYAN )
      {
        this.type = Ball.WHITE;
      }*/
      else
      {
        if (m_target == 1)
        {
          m_target = 2;
        }
        else
        {
          m_target = 1;
          this.type = Ball.RED;
        }
      }
      configure();
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      if (percent == 1 && ball.type == m_type)
      {
        ball.removeFromTile();
        m_consumed++;
        configure();
        tile.dispatchEvent(new BallEvent(BallEvent.BALL_CONSUMED, ball, tile));
      }
    }
    
    public override function reset():void
    {
      m_consumed = 0;
      configure();
    }
    
    public function get isComplete():Boolean
    {
      return m_consumed >= m_target;
    }
    
    public override function save():uint
    {
      return ( m_target << 3 ) | ( m_type & 0x7 );
    }
    
    public override function get id():uint
    {
      return GadgetManager.s_gadgets.indexOf(Goal);
    }
  }
}