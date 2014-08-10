package src.game 
{
	import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import src.game.utils.AssetManager;
  import src.game.utils.ConfigManager;
  
  import starling.core.Starling;
	
	/**
   * Document class for the game
   * @author David Talley
   */
  public class StartEditor extends Sprite 
  {
    private var m_starling:Starling;
    
    public function StartEditor() 
    {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(Event.RESIZE, stageResized);
      
      m_starling = new Starling(ApplicationEditor, stage);
      m_starling.start();
      
      ConfigManager.ENVIRONMENT = ConfigManager.ENVIRONMENT_EDITOR;
      
      AssetManager.Initialize();      
      AssetManager.LoadBundle([
        "assets/config_editor.json"
      ], null, this.LoadConfig);
       
       stageResized(null);
    }
    
    private function stageResized(e:Event):void
    {
      m_starling.stage.stageWidth = stage.stageWidth;
      m_starling.stage.stageHeight = stage.stageHeight;
      m_starling.viewPort.setTo(0, 0, stage.stageWidth, stage.stageHeight);
    }
    
    private function LoadConfig(err:Error):void
    {
      if ( err )
      {
        throw err;
        return;
      }
      
      ConfigManager.load();
      
      AssetManager.LoadBundle([
        "assets/textures/" + ConfigManager.TEXTURE_SET + "/game.json",
        "assets/textures/" + ConfigManager.TEXTURE_SET + "/game.png"
      ], null, this.Ready);
    }
    
    private function Ready(err:Error):void
    {
      if ( err )
      {
        throw err;
        return;
      }
      
      (m_starling.root as ApplicationEditor).start();
    }
  }

}