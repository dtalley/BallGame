package src.game 
{
	/**
   * ...
   * @author 
   */
  public class PuzzleList 
  {
    private var m_asset:String;
    
    private var m_head:PuzzleList;
    private var m_parents:Vector.<PuzzleList> = new Vector.<PuzzleList>();
    private var m_children:Vector.<PuzzleList> = new Vector.<PuzzleList>();
    
    public function PuzzleList(asset:String) 
    {
      m_head = this;
      m_asset = asset;
    }
    
    public function addParent(parent:PuzzleList):PuzzleList
    {
      if (m_parents.indexOf(parent) < 0)
      {
        m_parents.push(parent);
        m_head = parent.head;
      }
      
      return parent;
    }
    
    public function addChild(child:PuzzleList):PuzzleList
    {
      if (m_children.indexOf(child) < 0)
      {
        m_children.push(child);
        child.addParent(this);
      }
      
      return child;
    }
    
    public function getParent(index:uint = 0):PuzzleList
    {
      if (index >= m_parents.length)
      {
        return null;
      }
      
      return m_parents[index];
    }
    
    public function getChild(index:uint = 0):PuzzleList
    {
      if (index >= m_children.length)
      {
        return null;
      }
      
      return m_children[index];
    }
    
    public function get head():PuzzleList
    {
      return m_head;
    }
    
    public function get asset():String
    {
      return m_asset;
    }
  }

}