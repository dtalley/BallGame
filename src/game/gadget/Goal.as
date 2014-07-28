package src.game.gadget
{
  import src.game.gadget.Gadget;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import src.game.Ball;
  
  public class Goal extends Gadget
  {
    private var m_base:Image;
    
    private var m_type:uint;
    
    public function Goal(type:uint = Ball.RED) 
    {
      m_type = type;
      configure();
      this.addChild(m_base);
    }
    
    private function configure():void
    {
      if (!m_base)
      {
        m_base = new Image(TextureManager.Get("atlas", "gadget_goal_red"));
      }
      
      if ( m_type == Ball.PURPLE )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_goal_purple");
      }
      else if ( m_type == Ball.BLUE )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_goal_blue");
      }
      else if ( m_type == Ball.RED )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_goal_red");
      }
      else if ( m_type == Ball.GREEN )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_goal_green");
      }
      else if ( m_type == Ball.YELLOW )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_goal_yellow");
      }
      else if ( m_type == Ball.CYAN )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_goal_cyan");
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
        this.type = Ball.GREEN;
      }
      else if ( m_type == Ball.GREEN )
      {
        this.type = Ball.BLUE;
      }
      else if ( m_type == Ball.BLUE )
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
      else
      {
        this.type = Ball.RED;
      }
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      
    }
    
    public override function reset():void
    {
      
    }
    
    public override function save():uint
    {
      return m_type;
    }
    
    public override function get id():uint
    {
      return GadgetManager.s_gadgets.indexOf(Goal);
    }
  }
}