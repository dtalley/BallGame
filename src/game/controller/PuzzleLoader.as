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
  import src.game.PuzzleList;
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
    
    private static var s_board:Board = null;
    private static var s_panel:Panel = null;
    
    private var m_puzzleToLoad:PuzzleList = null;
    
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
      
      if (AssetManager.Get(m_puzzleToLoad.asset))
      {
        puzzleLoaded();
      }
      else
      {
        AssetManager.LoadBundle([
          m_puzzleToLoad.asset
        ], null, this.puzzleLoaded);
      }
    }
    
    private function createBoard():void
    {
      if (s_board)
      {
        return;
      }
      
      s_board = new Board();
      Starling.current.stage.addChild(s_board);
      s_board.x = Math.round(ConfigManager.TILE_SIZE / 4);
      s_board.y = Math.round(( Starling.current.stage.stageHeight / 2 ) - ( ( Board.rows * ConfigManager.TILE_SIZE ) / 2 ));
      
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
      
      m_puzzleConfiguration.puzzle = m_puzzleToLoad;
      trace(m_puzzleToLoad.asset);
      var puzzle:ByteArray = AssetManager.Get(m_puzzleToLoad.asset);
      m_puzzleToLoad = null;
      
      puzzle.position = 0;
      if ( m_puzzleConfiguration.load(puzzle) )
      {
        s_board.clearTiles();
        s_board.load(puzzle);
      }
      
      this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "planner", new PlannerConfiguration(s_board, s_panel, m_puzzleConfiguration)));
    }
    
    public function Deactivate():void
    {
      
    }
  }

}