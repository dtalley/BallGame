package src.game 
{
	import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import src.game.utils.AssetManager;
  
  import starling.core.Starling;
	
	/**
   * Document class for the game
   * @author David Talley
   */
  public class Start extends Sprite 
  {
    private var m_starling:Starling;
    
    public function Start() 
    {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      AssetManager.Initialize();      
      AssetManager.LoadBundle([
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
      
      m_starling = new Starling(Application, stage);
      m_starling.start();
      //m_starling.showStats = true;
    }
  }

}