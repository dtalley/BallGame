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
  import src.game.utils.ConfigManager;
  import src.game.utils.MathX;
  import starling.events.Touch;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   */
  public class Simulator extends EventDispatcher implements Controller 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_puzzleConfiguration:PuzzleConfiguration = new PuzzleConfiguration();
    
    private var m_tree:ButtonTree;
    
    private var m_speed:Number = 0.15;
    private var m_accumulator:Number = 0.0;
    
    private var m_balls:Vector.<Ball>;
    
    private var m_reset:ButtonTree;
    
    public function Simulator() 
    {      
      m_tree = new ButtonTree("root", 0);      
      m_tree.createChild("", ButtonTree.BLANK);
      m_tree.createChild("", ButtonTree.BLANK);
      m_tree.createChild("", ButtonTree.BLANK);
      m_tree.createChild("", ButtonTree.BLANK);
      m_tree.createChild("", ButtonTree.BLANK);
      m_tree.createChild("", ButtonTree.BLANK);
      m_tree.createChild("", ButtonTree.BLANK);
      m_reset = m_tree.createChild("reset", ButtonTree.NORMAL);
      
      m_reset.addEventListener("activated", this.resetActivated);
    }
    
    private function boardComplete(e:BoardEvent):void
    {
      if (ConfigManager.ENVIRONMENT == ConfigManager.ENVIRONMENT_EDITOR)
      {
        this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "planner", new PlannerConfiguration(m_board, m_panel)));
      }
      else
      {
        this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "puzzleResult", new PuzzleResultConfiguration(m_board, m_panel, m_puzzleConfiguration)));
      }
    }
    
    private function resetActivated(e:Event):void
    {
      this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "planner", new PlannerConfiguration(m_board, m_panel)));
    }
    
    public function Update(elapsed:Number):void
    {
      m_accumulator += elapsed;
      
      while (m_accumulator >= m_speed)
      {
        for ( var i:int = 0; i < m_board.ballCount; i++ )
        {
          if ( m_balls[i].tile && m_balls[i].target )
          {
            m_balls[i].tile = m_balls[i].target;
          }
        }
        
        for ( i = 0; i < m_board.ballCount; i++ )
        {
          if ( m_balls[i].tile )
          {
            m_balls[i].calculateTarget();
          }
        }
        m_accumulator -= m_speed;
      }
      
      var percent:Number = m_accumulator / m_speed;
      
      for ( i = 0; i < m_board.ballCount; i++ )
      {
        if (m_balls[i].tile)
        {
          m_balls[i].moveFromSourceToTarget(percent);
        }
      }
      
      for ( i = 0; i < m_board.ballCount; i++ )
      {
        for ( var j:int = i + 1; j < m_board.ballCount; j++ )
        {
          if (m_balls[i].intersects(m_balls[j]))
          {
            this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "puzzleResult", new PuzzleResultConfiguration(m_board, m_panel, m_puzzleConfiguration, true)));
          }
        }
      }
    }
    
    public function Activate(configuration:ControllerConfiguration, previous:Controller):void
    {      
      if (configuration is SimulatorConfiguration)
      {
        var simulatorConfiguration:SimulatorConfiguration = configuration as SimulatorConfiguration;
        
        m_board = simulatorConfiguration.board;  
        m_panel = simulatorConfiguration.panel;
        
        m_puzzleConfiguration.copy(simulatorConfiguration.configuration);
        
        m_balls = m_board.balls;
        m_board.addEventListener(BoardEvent.BOARD_COMPLETE, this.boardComplete);
        
        m_accumulator = 0;
      
        m_panel.loadTree(m_tree);
        
        for ( var i:int = 0; i < m_board.ballCount; i++ )
        {
          m_balls[i].calculateTarget();
        }
      }
    }
    
    public function Deactivate():void
    {
      
    }
  }

}