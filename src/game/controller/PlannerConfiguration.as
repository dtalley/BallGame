package src.game.controller 
{
  import src.game.Board;
  import src.game.Panel;
  import src.game.PuzzleConfiguration;
	/**
   * ...
   * @author 
   */
  public class PlannerConfiguration extends ControllerConfiguration 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    private var m_configuration:PuzzleConfiguration;
   
    public function PlannerConfiguration(board:Board, panel:Panel, configuration:PuzzleConfiguration = null) 
    {
      super();
			
      m_board = board;
      m_panel = panel;
      m_configuration = configuration;
    }
    
    public function get board():Board
    {
      return m_board;
    }
    
    public function get panel():Panel
    {
      return m_panel;
    }
    
    public function get puzzleConfiguration():PuzzleConfiguration
    {
      return m_configuration;
    }
  }

}