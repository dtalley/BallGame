package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.gadget.Dispurse;
  import src.game.gadget.Gadget;
  import src.game.gadget.Rally;
  import src.game.gadget.Redirect;
  import src.game.gadget.Reverse;
  import src.game.Panel;
  import src.game.Tile;
  import src.game.utils.AssetManager;
  import src.game.utils.ConfigManager;
  import starling.events.Touch;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   */
  public class SplashWeb extends EventDispatcher implements Controller
  {    
    public function SplashWeb() 
    {
      
    }
    
    public function Update(elapsed:Number):void
    {
      
    }
    
    public function Activate(configuration:ControllerConfiguration, previous:Controller):void
    {
      AssetManager.LoadBundle([
        "assets/textures/hd/main.png",
        "assets/textures/hd/main.json"
      ], null, this.Ready);
    }
    
    public function Ready(err:Error):void
    {
      if (err)
      {
        throw err;
        return;
      }
      
      this.dispatchEvent(new Event("assetsLoaded"));
    }
    
    public function Deactivate():void
    {
      
    }
  }

}