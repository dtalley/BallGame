package src.game.gadget
{
  import src.game.gadget.Gadget;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import src.game.Ball;
  
  public class Blank extends Gadget
  {
    private var m_base:Image;
    
    public function Blank() 
    {
      m_base = new Image(TextureManager.Get("atlas", "goal_red"));
      this.addChild(m_base);
    }
    public override function tap():void
    {
      
    }
    
    public override function act(ball:Ball, percent:Number):void
    {
      
    }
    
    public override function reset():void
    {
      
    }
    
    public override function get id():uint
    {
      return GadgetManager.s_gadgets.indexOf(Blank);
    }
  }
}