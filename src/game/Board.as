package src.game 
{
  import src.game.utils.MathX;
	import starling.display.Sprite;
	
	/**
   * ...
   * @author 
   */
  public class Board extends Sprite 
  {
    private var m_tiles:Vector.<Tile> = new Vector.<Tile>();
    private var m_balls:Vector.<Ball> = new Vector.<Ball>();
    
    public static const tileSize:Number = 74;
    
    public static const rows:int = 8;
    public static const columns:int = 11;
    
    public static const padding:int = 5;
    
    public var m_ballCount:uint = 0;
    public var m_tileCount:uint = 0;
    
    public function Board() 
    {
      for ( var i:int = 0 - padding; i < rows + padding; i++ )
      {
        for ( var j:int = 0 - padding; j < columns + padding; j++ )
        {
          var tile:Tile = new Tile(MathX.within(i+1, 1, rows) && MathX.within(j+1, 1, columns));
          this.addChild(tile);
          tile.x = j * tileSize;
          tile.y = i * tileSize;
          
          if ( j > 0 - padding )
          {
            tile.left = this.m_tiles[this.m_tiles.length - 1];
          }
          
          if ( i > 0 - padding )
          {
            tile.top = this.m_tiles[this.m_tiles.length - ( columns + ( padding * 2 ) )];
          }
          
          this.m_tiles.push(tile);
          m_tileCount++;
        }
      }
    }
    
    public function get tileCount():uint
    {
      return m_tileCount;
    }
    
    public function addBall(ball:Ball):void
    {
      if ( !this.contains(ball) )
      {
        this.addChild(ball);
        m_balls.push(ball);
        m_ballCount++;
      }
    }
    
    public function removeBall(ball:Ball):void
    {
      if ( this.contains(ball) )
      {
        this.removeChild(ball);
        m_balls.splice(m_balls.indexOf(ball), 1);
        m_ballCount--;
      }
    }
    
    public function getTileAt(x:Number, y:Number):Tile
    {
      var realX:Number = Math.floor(x / tileSize) + padding;
      var realY:Number = Math.floor(y / tileSize) + padding;
      var index:int = ( realY * ( columns + ( padding * 2 ) ) ) + realX;
      
      if ( index >= 0 && index < m_tiles.length )
      {
        return m_tiles[index];
      }
      
      return null;
    }
    
    public function clearTiles():void
    {
      for ( var i:int = 0; i < m_tiles.length; i++ )
      {
        if ( m_tiles[i].isValid )
        {
          m_tiles[i].close();
          m_tiles[i].open();
        }
      }
    }
    
    public function get ballCount():uint
    {
      return m_ballCount;
    }
    
    public function get balls():Vector.<Ball>
    {
      return m_balls;
    }
    
    public function get tiles():Vector.<Tile>
    {
      return m_tiles;
    }
    
    public function prune():void
    {
      for ( var i:uint = 0; i < m_balls.length; i++ )
      {
        if ( m_balls[i].tile == null )
        {
          var ball:Ball = m_balls[i];
          m_balls.splice(i, 1);
          i--;
          m_ballCount--;
          
          ball.dispose();
        }
      }
    }
  }

}