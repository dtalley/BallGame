package src.game.controller 
{
  import src.game.Board;
  import src.game.Panel;
	/**
   * ...
   * @author 
   */
  public class SimulatorConfiguration extends ControllerConfiguration 
  {
    private var m_board:Board;
    private var m_panel:Panel;
   
    public function SimulatorConfiguration(board:Board, panel:Panel) 
    {
      super();
			
      m_board = board;
      m_panel = panel;
    }
    
    public function get board():Board
    {
      return m_board;
    }
    
    public function get panel():Panel
    {
      return m_panel;
    }
  }

}