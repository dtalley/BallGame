package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.event.ControllerEvent;
  import src.game.gadget.Dispurse;
  import src.game.gadget.Gadget;
  import src.game.gadget.Rally;
  import src.game.gadget.Redirect;
  import src.game.gadget.Reverse;
  import src.game.Panel;
  import src.game.Tile;
  import src.game.utils.ConfigManager;
  import src.game.utils.TextureManager;
  import starling.core.Starling;
  import starling.display.Image;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.textures.TextureSmoothing;
	/**
   * ...
   * @author 
   */
  public class Main extends EventDispatcher implements Controller
  {
    private var m_play:Image;
    
    public function Main() 
    {
      m_play = new Image(TextureManager.Get("main", "button_play"));
      Starling.current.stage.addChild(m_play);
      m_play.x = Math.round(Starling.current.stage.stageWidth / 2 - m_play.width / 2);
      m_play.y = Math.round(Starling.current.stage.stageHeight / 2 - m_play.height / 2);
      m_play.smoothing = TextureSmoothing.NONE;
      m_play.addEventListener(TouchEvent.TOUCH, this.playTouched);
    }
    
    private function playTouched(e:TouchEvent):void
    {
      if (e.touches[0].phase == "ended")
      {
        this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "puzzleLoader", new PuzzleLoaderConfiguration("../files/puzzles/d01.l01.bpf")));
      }
    }
    
    public function Update(elapsed:Number):void
    {
      
    }
    
    public function Activate(configuration:ControllerConfiguration, previous:Controller):void
    {
      
    }
    
    public function Deactivate():void
    {
      
    }
  }

}