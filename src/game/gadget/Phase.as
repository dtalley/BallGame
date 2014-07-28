package src.game.gadget
{
  import src.game.gadget.Gadget;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import src.game.Ball;
  
  public class Phase extends Gadget
  {
    private var m_base:Image;
    
    private var m_type:uint;
    
    public function Phase(type:uint = Ball.PURPLE) 
    {
      m_type = type;
      if ( type == Ball.PURPLE )
      {
        m_base = new Image(TextureManager.Get("atlas", "gadget_phase_purple"));
      }
      else if ( type == Ball.BLUE )
      {
        m_base = new Image(TextureManager.Get("atlas", "gadget_phase_blue"));
      }
      else if ( type == Ball.RED )
      {
        m_base = new Image(TextureManager.Get("atlas", "gadget_phase_red"));
      }
      this.addChild(m_base);
    }
    
    public function set type(val:uint):void
    {
      m_type = val;
      if ( m_type == Ball.PURPLE )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_phase_purple");
      }
      else if ( m_type == Ball.BLUE )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_phase_blue");
      }
      else if ( m_type == Ball.RED )
      {
        m_base.texture = TextureManager.Get("atlas", "gadget_phase_red");
      }
    }
    
    public function get type():uint
    {
      return m_type;
    }
    
    public override function tap():void
    {
      if ( m_type == Ball.PURPLE )
      {
        this.type = Ball.BLUE;
      }
      else if ( m_type == Ball.BLUE )
      {
        this.type = Ball.RED;
      }
      else
      {
        this.type = Ball.PURPLE;
      }
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      
    }
    
    public override function permit(ball:Ball):void
    {
      if ( ball.type != m_type )
      {
        ball.target = null;
        ball.direction.x = 0;
        ball.direction.y = 0;
      }
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
      return GadgetManager.s_gadgets.indexOf(Phase);
    }
  }
}