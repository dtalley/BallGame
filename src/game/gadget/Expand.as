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
    
    private var m_rotated:Boolean = false;
    
    public function Expand() 
    {
      m_base = new Image(TextureManager.Get("atlas", "gadget_expand"));
      
      m_base.alignPivot();
      m_base.x = ConfigManager.TILE_SIZE / 2;
      m_base.y = ConfigManager.TILE_SIZE / 2;
      
      this.addChild(m_base);
    }
    
    public override function tap():void
    {
      m_rotated = !m_rotated;
      if (m_rotated)
      {
        m_base.rotation = Math.PI / 2;
      }
      else
      {
        m_base.rotation = 0;
      }
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      
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
      return GadgetManager.s_gadgets.indexOf(Expand);
    }
  }
}