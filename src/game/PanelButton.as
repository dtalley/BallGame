package src.game 
{
	import flash.events.TimerEvent;
  import flash.utils.Timer;
  import src.game.utils.TextureManager;
  import starling.display.Image;
  import starling.display.Sprite;
  import starling.textures.TextureSmoothing;

  public class PanelButton extends Sprite
  {
    private var m_base:Image;
    private var m_icon:Image = null;
    
    private var m_selected:Boolean = false;
    
    public function PanelButton():void
    {
      this.touchable = false;
      m_base = new Image(TextureManager.Get("atlas", "panel_button_out"));
      this.addChild(m_base);
      m_base.visible = false;
      m_base.smoothing = TextureSmoothing.NONE;
    }
    
    public function setIcon(name:String):void
    {
      if ( !name )
      {
        this.removeIcon();
        return;
      }
      
      if ( !m_icon )
      {
        m_icon = new Image(TextureManager.Get("atlas", "panel_icon_" + name));
        m_icon.smoothing = TextureSmoothing.NONE;
      }
      else
      {
        m_icon.texture = TextureManager.Get("atlas", "panel_icon_" + name);
      }
      
      this.addChild(m_icon);
      m_base.visible = true;
      this.touchable = true;
    }
    
    public function removeIcon():void
    {
      if ( m_icon )
      {
        this.removeChild(m_icon);
      }
      
      m_base.visible = false;
      this.touchable = false;
    }
    
    public function select():void
    {
      m_base.texture = TextureManager.Get("atlas", "panel_button_selected");
      m_selected = true;
    }
    
    public function deselect():void
    {
      m_base.texture = TextureManager.Get("atlas", "panel_button_out");
      m_selected = false;
    }
    
    public function activate():void
    {
      m_base.texture = TextureManager.Get("atlas", "panel_button_down");
      
      var timer:Timer = new Timer(500, 1);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.deactivate);
      timer.start();
    }
    
    public function deactivate(e:TimerEvent = null):void
    {
      if ( e )
      {
        e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, this.deactivate);
      }
      
      if (m_selected)
      {
        return;
      }
      
      m_base.texture = TextureManager.Get("atlas", "panel_button_out");
    }
    
    public function get isSelected():Boolean
    {
      return m_selected;
    }
  }
}