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
  public class StartEditor extends Sprite 
  {
    private var m_starling:Starling;
    
    public function StartEditor() 
    {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      m_starling = new Starling(ApplicationEditor, stage);
      m_starling.start();
      
      AssetManager.Initialize();      
      AssetManager.LoadBundle([
        "assets/config_editor.json",
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
      
      (m_starling.root as ApplicationEditor).start();
    }
  }

}