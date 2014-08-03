package src.game.controller 
{
	/**
   * ...
   * @author 
   */
  public class PuzzleLoaderConfiguration extends ControllerConfiguration 
  {
    private var m_puzzle:String = null;
   
    public function PuzzleLoaderConfiguration(puzzle:String = null) 
    {
      super();
			
      m_puzzle = puzzle;
    }
    
    public function get puzzle():String
    {
      return m_puzzle;
    }
  }

}