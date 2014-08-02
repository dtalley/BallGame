package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.event.BoardEvent;
  import src.game.Panel;
  import src.game.Tile;
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
    
    private var m_tree:ButtonTree;
    
    private var m_speed:Number = 0.15;
    private var m_accumulator:Number = 0.0;
    
    private var m_balls:Vector.<Ball>;
    
    private var m_reset:ButtonTree;
    
    public function Simulator(board:Board, panel:Panel) 
    {
      m_board = board;  
      m_panel = panel;
      
      m_balls = m_board.balls;
      
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
      
      m_board.addEventListener(BoardEvent.BOARD_COMPLETE, this.boardComplete);
    }
    
    private function boardComplete(e:BoardEvent):void
    {
      this.dispatchEvent(new Event("startPlanner"));
    }
    
    private function resetActivated(e:Event):void
    {
      this.dispatchEvent(new Event("startPlanner"));
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
    }
    
    public function Activate(previous:Controller):void
    {      
      m_accumulator = 0;
      
      m_panel.loadTree(m_tree);
      
      for ( var i:int = 0; i < m_board.ballCount; i++ )
      {
        m_balls[i].calculateTarget();
      }
    }
    
    public function Deactivate():void
    {
      
    }
  }

}