package src.game.controller 
{
  import src.game.PuzzleList;
	/**
   * ...
   * @author 
   */
  public class PuzzleLoaderConfiguration extends ControllerConfiguration 
  {
    private var m_puzzle:PuzzleList = null;
   
    public function PuzzleLoaderConfiguration(puzzle:PuzzleList = null) 
    {
      super();
			
      m_puzzle = puzzle;
    }
    
    public function get puzzle():PuzzleList
    {
      return m_puzzle;
    }
  }

}