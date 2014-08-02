package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.gadget.Dispurse;
  import src.game.gadget.Gadget;
  import src.game.gadget.Rally;
  import src.game.gadget.Redirect;
  import src.game.gadget.Reverse;
  import src.game.Panel;
  import src.game.Tile;
  import src.game.utils.ConfigManager;
  import starling.events.Touch;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   */
  public class Main extends EventDispatcher implements Controller
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    public function Main(board:Board, panel:Panel) 
    {
      m_board = board;
      m_panel = panel;
    }
    
    public function Update(elapsed:Number):void
    {
      
    }
    
    public function Activate(previous:Controller):void
    {
      m_board.visible = false;
      m_panel.visible = false;
    }
    
    public function Deactivate():void
    {
      
    }
  }

}