package src.game.gadget 
{
  import src.game.Ball;
  import src.game.Tile;
	import starling.display.Sprite;
	
	/**
   * ...
   * @author 
   */
  public class Gadget extends Sprite 
  {        
    private var m_tile:Tile = null;
    private var m_persistent:Boolean = false;
    public function Gadget() 
    {
      
    }
    
    public function get tile():Tile
    {
      return m_tile;
    }
    
    public function set tile(tile:Tile):void
    {
      if ( m_tile == tile )
      {
        return;
      }
      
      if ( m_tile )
      {
        m_tile.clearGadget();
      }
      
      m_tile = tile;
      
      if ( m_tile )
      {
        m_tile.addGadget(this);
      }
    }
    
    public function removeFromTile():void
    {
      if ( m_tile )
      {
        m_tile.clearGadget();
        m_tile = null;
      }
    }
    
    public function tap():void
    {
      
    }
    
    public function planTap():void
    {
      
    }
    
    public function act(ball:Ball, percent:Number):void
    {
      
    }
    
    public function permit(ball:Ball):void
    {
      
    }
    
    public function reset():void
    {
      
    }
    
    public function save():uint
    {
      return 0;
    }
    
    public function get isMoveable():Boolean
    {
      return false;
    }
    
    public function get isRemoveable():Boolean
    {
      return false;
    }
    
    public function get id():uint
    {
      return 0;
    }
    
    public function persist():void
    {
      m_persistent = true;
    }
    
    public function get isPersistent():Boolean
    {
      return m_persistent;
    }
  }

}