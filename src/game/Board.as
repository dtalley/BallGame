package src.game 
{
  import flash.utils.ByteArray;
  import src.game.event.BallEvent;
  import src.game.event.BoardEvent;
  import src.game.gadget.Gadget;
  import src.game.gadget.GadgetManager;
  import src.game.gadget.Goal;
  import src.game.utils.ConfigManager;
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
    
    public static const rows:int = 8;
    public static const columns:int = 11;
    
    public var m_ballCount:uint = 0;
    public var m_tileCount:uint = 0;
    
    public function Board() 
    {
      var padding:uint = ConfigManager.PADDING;
      var tileSize:uint = ConfigManager.TILE_SIZE;
      
      for ( var i:int = 0 - padding; i < rows + padding; i++ )
      {
        for ( var j:int = 0 - padding; j < columns + padding; j++ )
        {
          var tile:Tile = new Tile(this, MathX.within(i + 1, 1, rows) && MathX.within(j + 1, 1, columns));
          tile.addEventListener(BallEvent.BALL_CONSUMED, this.ballConsumed);
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
    
    private function ballConsumed(e:BallEvent):void
    {
      if (e.tile.gadget is Goal)
      {
        var goal:Goal = e.tile.gadget as Goal;
        if ( goal.isComplete )
        {
          for ( var i:int = 0; i < m_tiles.length; i++ )
          {
            if ( m_tiles[i].isValid && m_tiles[i].hasGadget && m_tiles[i].gadget is Goal && !(m_tiles[i].gadget as Goal).isComplete )
            {
              return;
            }
          }
          
          dispatchEvent(new BoardEvent(BoardEvent.BOARD_COMPLETE));
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
      var tileSize:uint = ConfigManager.TILE_SIZE;
      var padding:uint = ConfigManager.PADDING;
      
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
    
    public function save(fs:ByteArray):void
    {
      fs.writeByte(rows);
      fs.writeByte(columns);
      
      var tileCount:uint = m_tiles.length;
      for ( var i:int = 0; i < tileCount; i++ )
      {
        var tile:Tile = m_tiles[i];
        if (!tile.isValid)
        {
          continue;
        }
        fs.writeByte(tile.defaultWallConfiguration.compress());
        
        var d0:uint = 0;
        if (tile.isOpen)
        {
          d0 |= ( 1 << 7 );
        }
        
        var d1:uint = 0xFF;
        
        var d2:uint = 0;        
        if (tile.hasGadget)
        {
          d1 &= 0x7;
          d1 |= ( tile.gadget.id << 3 );
          d2 = tile.gadget.save();
        }
        
        if (tile.hasBall)
        {
          d1 &= 0xF8;
          d1 |= ( tile.getBall(0).type & 0x7 );
        }
        
        fs.writeByte(d0);
        fs.writeByte(d1);
        fs.writeShort(d2);
      }
    }
    
    public function load(fs:ByteArray):void
    {      
      var frows:int = fs.readByte();
      var fcolumns:int = fs.readByte();
      
      if (frows != rows || fcolumns != columns)
      {
        trace("Puzzle file is incompatible with current board");
        return;
      }
      
      var tileCount:uint = m_tiles.length;
      for ( var i:int = 0; i < tileCount; i++ )
      {
        var tile:Tile = m_tiles[i];
        if (!tile.isValid)
        {
          continue;
        }
        tile.clearGadget();
        tile.clearPlan();
        while (tile.hasBall)
        {
          tile.removeBallAt(0);
        }
        
        var wc:uint = fs.readByte();
        tile.defaultWallConfiguration.decompress(wc);
        
        var d0:uint = fs.readByte();
        
        if ( ( d0 & ( 1 << 7 ) ) == 0 )
        {
          tile.close();
        }
        
        var d1:uint = fs.readByte() & 0xFF;
        var d2:uint = fs.readShort() & 0xFFFF;
        
        var gid:uint = d1 >>> 3;
        if (gid < 0x1F)
        {
          var gclass:Class = GadgetManager.s_gadgets[gid];
          var gadget:Gadget = new gclass(d2);
          gadget.tile = tile;
          tile.lockDefault();
        }
        
        var btype:uint = d1 & 0x7;
        if (btype < 0x7)
        {
          var ball:Ball = new Ball(btype);
          addBall(ball);
          ball.tile = tile;
          tile.lockDefault();
        }
        
        tile.configure(true, true);
      }
    }
  }

}