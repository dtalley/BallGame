package src.game.controller 
{
  import src.game.Board;
  import src.game.Panel;
  import src.game.PuzzleConfiguration;
	/**
   * ...
   * @author 
   */
  public class PuzzleResultConfiguration extends ControllerConfiguration 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    private var m_configuration:PuzzleConfiguration;
    private var m_failure:Boolean;
   
    public function PuzzleResultConfiguration(board:Board, panel:Panel, configuration:PuzzleConfiguration, failure:Boolean = false) 
    {
      super();
			
      m_board = board;
      m_panel = panel;
      m_configuration = configuration;
      m_failure = failure;
    }
    
    public function get failure():Boolean
    {
      return m_failure;
    }
    
    public function get board():Board
    {
      return m_board;
    }
    
    public function get panel():Panel
    {
      return m_panel;
    }
    
    public function get configuration():PuzzleConfiguration
    {
      return m_configuration;
    }
  }

}