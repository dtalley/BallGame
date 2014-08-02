package src.game 
{
	import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import src.game.utils.AssetManager;
  import src.game.utils.ConfigManager;
  
  import starling.core.Starling;
	
	/**
   * ...
   * @author 
   */
  public class StartWeb extends Sprite 
  {
    private var m_starling:Starling;
    
    public function StartWeb() 
    {
      super();
			
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      m_starling = new Starling(ApplicationWeb, stage);
      m_starling.start();
      
      ConfigManager.ENVIRONMENT = ConfigManager.ENVIRONMENT_WEB;
      
      AssetManager.Initialize();      
      AssetManager.LoadBundle([
        "assets/config_web.json"
      ], null, this.Ready);
    }
    
    private function Ready(err:Error):void
    {
      if ( err )
      {
        throw err;
        return;
      }
      
      (m_starling.root as ApplicationWeb).start();
    }
  }

}