package src.game 
{
	import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import src.game.utils.AssetManager;
  
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
      
      AssetManager.Initialize();      
      AssetManager.LoadBundle([
        "assets/config_web.json",
        "assets/textures/hd/atlas.png",
        "assets/textures/hd/atlas.json"
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