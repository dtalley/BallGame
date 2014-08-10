package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.event.BoardEvent;
  import src.game.event.ControllerEvent;
  import src.game.Panel;
  import src.game.PuzzleConfiguration;
  import src.game.Tile;
  import starling.events.Touch;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   */
  public class PuzzleResult extends EventDispatcher implements Controller 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_puzzleConfiguration:PuzzleConfiguration = new PuzzleConfiguration();
    
    public function PuzzleResult() 
    {      
      
    }
    
    public function Update(elapsed:Number):void
    {
      
    }
    
    public function Activate(configuration:ControllerConfiguration, previous:Controller):void
    {      
      if (configuration is PuzzleResultConfiguration)
      {
        var specificConfiguration:PuzzleResultConfiguration = configuration as PuzzleResultConfiguration;
        
        m_board = specificConfiguration.board;  
        m_panel = specificConfiguration.panel;
        
        m_puzzleConfiguration.copy(specificConfiguration.configuration);
        
        if (specificConfiguration.failure)
        {
          this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "puzzleLoader", new PuzzleLoaderConfiguration(m_puzzleConfiguration.puzzle)));
          return;
        }
        
        m_puzzleConfiguration.puzzle = m_puzzleConfiguration.puzzle.getChild();
        if (m_puzzleConfiguration.puzzle)
        {
          this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "puzzleLoader", new PuzzleLoaderConfiguration(m_puzzleConfiguration.puzzle)));
        }
        else
        {
          this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "main"));
        }
      }
    }
    
    public function Deactivate():void
    {
      
    }
  }

}