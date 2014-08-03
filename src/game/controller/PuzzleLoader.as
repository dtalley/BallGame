package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.utils.ByteArray;
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
  import src.game.PuzzleConfiguration;
  import src.game.Tile;
  import src.game.utils.AssetManager;
  import src.game.utils.ConfigManager;
  import starling.core.Starling;
  import starling.events.Touch;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   * 
   */
  public class PuzzleLoader extends EventDispatcher implements Controller
  {
    private static var s_gameAssetsLoaded:Boolean = false;
    
    private static var s_board:Board;
    private static var s_panel:Panel;
    
    private var m_puzzleToLoad:String = null;
    
    private var m_puzzleConfiguration:PuzzleConfiguration = new PuzzleConfiguration();
    
    public function PuzzleLoader() 
    {
      
    }
    
    public function Update(elapsed:Number):void
    {
      
    }
    
    public function Activate(configuration:ControllerConfiguration, previous:Controller):void
    {
      if (configuration is PuzzleLoaderConfiguration)
      {
        var puzzleLoaderConfiguration:PuzzleLoaderConfiguration = configuration as PuzzleLoaderConfiguration;
        
        m_puzzleToLoad = puzzleLoaderConfiguration.puzzle;
      }
      
      if (!s_gameAssetsLoaded)
      {
        AssetManager.LoadBundle([
          "assets/textures/hd/game.png",
          "assets/textures/hd/game.json"
        ], null, this.gameAssetsLoaded);
      }
      else
      {
        gameAssetsLoaded();
      }
    }
    
    private function gameAssetsLoaded(e:Error = null):void
    {
      if (e)
      {
        throw e;
        return;
      }
      
      if (!s_gameAssetsLoaded)
      {
        s_gameAssetsLoaded = true;
        this.dispatchEvent(new Event("assetsLoaded"));
      }
      
      if (!s_board)
      {
        this.createBoard();
      }
      
      if (AssetManager.Get(m_puzzleToLoad))
      {
        puzzleLoaded();
      }
      else
      {
        AssetManager.LoadBundle([
          m_puzzleToLoad
        ], null, this.puzzleLoaded);
      }
    }
    
    private function createBoard():void
    {
      s_board = new Board();
      Starling.current.stage.addChild(s_board);
      s_board.x = ( Starling.current.stage.stageWidth / 2 ) - ( ( Board.columns * ConfigManager.TILE_SIZE ) / 2 );
      s_board.y = ( Starling.current.stage.stageHeight / 2 ) - ( ( Board.rows * ConfigManager.TILE_SIZE ) / 2 );
      
      if ( s_board.x < s_board.y )
      {
        s_board.y = s_board.x;
      }
      else
      {
        s_board.x = s_board.y;
      }
      
      s_panel = new Panel();
      Starling.current.stage.addChild(s_panel);
      s_panel.x = Starling.current.stage.stageWidth - s_panel.width - s_board.x;
      s_panel.y = s_board.y - 4;
    }
    
    private function puzzleLoaded(e:Error = null):void
    {
      if (e)
      {
        throw e;
        return;
      }
      
      var puzzle:ByteArray = AssetManager.Get(m_puzzleToLoad);
      m_puzzleToLoad = null;
      
      if ( m_puzzleConfiguration.load(puzzle) )
      {
        s_board.load(puzzle);
      }
      
      this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "planner", new PlannerConfiguration(s_board, s_panel, m_puzzleConfiguration)));
    }
    
    public function Deactivate():void
    {
      
    }
  }

}