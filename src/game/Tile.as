package src.game 
{
  import flash.events.IMEEvent;
  import src.game.gadget.Gadget;
  import src.game.utils.ConfigManager;
  import starling.textures.Texture;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.textures.TextureSmoothing;
	
	/**
   * ...
   * @author 
   */
  public class Tile extends Sprite 
  {
    public static var L_WALL:uint = 0;
    public static var T_WALL:uint = 1;
    public static var R_WALL:uint = 2;
    public static var B_WALL:uint = 3;
    public static var TL_CORNER:uint = 4;
    public static var TR_CORNER:uint = 5;
    public static var BR_CORNER:uint = 6;
    public static var BL_CORNER:uint = 7;
    public static var CENTER:uint = 8;
    
    private var m_open:Boolean = false;
    private var m_valid:Boolean = false;
    
    private var m_top:Tile = null;
    private var m_bottom:Tile = null;
    private var m_left:Tile = null;
    private var m_right:Tile = null;
    
    private var m_defaultWallConfiguration:WallConfiguration = new WallConfiguration();
    private var m_wallConfiguration:WallConfiguration = new WallConfiguration();
    
    private var m_baseImage:Image;
    private var m_wallImage:Image;
    
    private var m_balls:Vector.<Ball> = new Vector.<Ball>();
    
    private var m_defaultBall:Ball;
    private var m_defaultBallType:uint;
    
    private var m_defaultGadget:Gadget;
    private var m_planGadget:Gadget;
    
    private var m_gadget:Gadget = null;
    
    private var m_board:Board = null;
    
    public function Tile(board:Board, open:Boolean) 
    {
      m_board = board;
      m_open = m_valid = open;
      
      var blank:Texture = null;
      if ( open )
      {
        blank = TextureManager.Get("game", "grid_open");
      }
      else
      {
        blank = TextureManager.Get("game", "grid_invalid");
      }
      
      if ( blank )
      {
        m_baseImage = new Image(blank);
        m_wallImage = new Image(blank);
        
        m_baseImage.smoothing = TextureSmoothing.NONE;
        m_wallImage.smoothing = TextureSmoothing.NONE;
        
        m_wallImage.alignPivot();
        m_wallImage.x = ConfigManager.TILE_SIZE / 2;
        m_wallImage.y = ConfigManager.TILE_SIZE / 2;
        
        this.addChild(m_baseImage);
      }
      else
      {
        throw new Error("Could not find tile image for a" + ( open ? "n open" : " closed" ) + " tile.");
      }
    }
    
    public function lockDefault():void
    {
      m_defaultBall = null;
      if ( m_balls.length > 0 )
      {
        m_defaultBall = m_balls[0];
        m_defaultBallType = m_defaultBall.type;
      }
      
      m_defaultGadget = null;
      if ( m_gadget )
      {
        m_defaultGadget = m_gadget;
      }
    }
    
    public function lockPlan():void
    {
      m_planGadget = null;
      if ( m_gadget && !m_defaultGadget )
      {
        m_planGadget = m_gadget;
      }
    }
    
    public function reset():void
    {
      clearGadget();
      
      while ( m_balls.length > 0 )
      {
        this.removeBallAt(0);
      }
      
      if ( m_defaultBall )
      {
        m_defaultBall.tile = this;
        m_defaultBall.type = m_defaultBallType;
      }
      
      if ( m_defaultGadget )
      {
        if ( m_gadget && m_gadget != m_defaultGadget )
        {
          m_gadget.removeFromTile();
          m_gadget = null;
        }
        m_defaultGadget.tile = this;
      }
      
      if ( m_gadget )
      {
        m_gadget.reset();
      }
    }
    
    public function resetPlan():void
    {
      if ( m_planGadget )
      {
        if ( m_gadget && m_gadget != m_planGadget )
        {
          m_gadget.removeFromTile();
          m_gadget = null;
        }
        m_planGadget.tile = this;
      }
      
      if ( m_gadget )
      {
        m_gadget.reset();
      }
    }
    
    public function clearPlan():void
    {
      m_planGadget = null;
    }
    
    public function modifyBalls(callback:Function):void
    {
      for ( var i:uint = 0; i < m_balls.length; i++ )
      {
        callback(m_balls[i]);
      }
    }
    
    public function addGadget(gadget:Gadget):void
    {
      if ( m_gadget == gadget )
      {
        return;
      }
      if ( m_gadget !== null )
      {
        this.clearGadget();
      }
      m_gadget = gadget;
      m_gadget.tile = this;
      this.addChildAt(m_gadget, 1);
    }
    
    public function clearGadget():void
    {
      if ( m_gadget !== null )
      {
        var gadget:Gadget = m_gadget;
        m_gadget = null;
        gadget.tile = null;
        this.removeChild(gadget);
      }
    }
    
    public function get hasGadget():Boolean
    {
      return m_gadget !== null;
    }
    
    public function get hasDefaultGadget():Boolean
    {
      return m_defaultGadget !== null && m_defaultGadget == m_gadget;
    }
    
    public function get gadget():Gadget
    {
      return m_gadget;
    }
    
    public function addBall(ball:Ball):void
    {
      var index:int = m_balls.indexOf(ball);
      if ( index < 0 )
      {
        m_balls.push(ball);
      }
    }
    
    public function removeBall(ball:Ball):void
    {
      if ( !ball )
      {
        return;
      }
      
      var index:int = m_balls.indexOf(ball);
      if ( index >= 0 )
      {
        m_balls.splice(index, 1);
        ball.removeFromTile();
      }
    }
    
    public function removeBallAt(index:uint):void
    {
      this.removeBall(this.getBall(index));
    }
    
    public function get hasBall():Boolean
    {
      return m_balls.length > 0;
    }
    
    public function getBall(index:uint = 0):Ball
    {
      if ( m_balls.length > index )
      {
        return m_balls[index];
      }
      
      return null;
    }
    
    public function getRegion(x:Number, y:Number):uint
    {
      var wallSize:Number = ConfigManager.TILE_SIZE / 3;
      
      if ( Math.sqrt(Math.pow((ConfigManager.TILE_SIZE / 2) - x, 2) + Math.pow((ConfigManager.TILE_SIZE / 2) - y, 2)) < 17 )
      {
        return Tile.CENTER;
      }
      else if ( x < wallSize && y > wallSize && y < ConfigManager.TILE_SIZE - wallSize )
      {
        return L_WALL;
      }
      else if ( y < wallSize && x > wallSize && x < ConfigManager.TILE_SIZE -wallSize )
      {
        return T_WALL;
      }
      else if ( x > ConfigManager.TILE_SIZE - wallSize && y > wallSize && y < ConfigManager.TILE_SIZE - wallSize )
      {
        return R_WALL;
      }
      else if ( y > ConfigManager.TILE_SIZE - wallSize && x > wallSize && x < ConfigManager.TILE_SIZE - wallSize )
      {
        return B_WALL;
      }
      else if ( x < ConfigManager.TILE_SIZE / 2 )
      {
        if ( y < ConfigManager.TILE_SIZE / 2 )
        {
          return TL_CORNER;
        }
        return BL_CORNER;
      }
      else
      {
        if ( y < ConfigManager.TILE_SIZE / 2 )
        {
          return TR_CORNER;
        }
        return BR_CORNER;
      }
    }
    
    public function close():void
    {
      if ( !m_valid )
      {
        return;
      }
      
      if ( m_open )
      {
        while ( m_balls.length > 0 )
        {
          this.removeBallAt(0);
        }
        
        this.clearGadget();
        
        m_open = false;
        m_baseImage.texture = TextureManager.Get("game", "grid_closed");
        
        m_defaultWallConfiguration.clear();
        
        if ( m_left && m_left.isOpen ) m_left.placeRightWall();
        else if ( m_left ) m_left.configure(true);
        
        if ( m_top && m_top.isOpen ) m_top.placeBottomWall();
        else if ( m_top ) m_top.configure(true);
        
        if ( m_right && m_right.isOpen ) m_right.placeLeftWall();
        else if ( m_right ) m_right.configure(true);
        
        if ( m_bottom && m_bottom.isOpen ) m_bottom.placeTopWall();
        else if ( m_bottom ) m_bottom.configure(true);
      }
    }
    
    public function open(skipValidation:Boolean = false):void
    {
      if ( !m_valid )
      {
        return;
      }
      
      if ( !m_open )
      {
        m_open = true;
        m_baseImage.texture = TextureManager.Get("game", "grid_open");
        
        m_defaultWallConfiguration.clear();
        
        if (!skipValidation)
        {
          if ( m_left && m_left.isOpen && m_left.isValid ) m_left.removeRightWall();
          else if ( m_left ) placeLeftWall();
          
          if ( m_top && m_top.isOpen && m_top.isValid ) m_top.removeBottomWall();
          else if ( m_top ) placeTopWall();
          
          if ( m_right && m_right.isOpen && m_right.isValid ) m_right.removeLeftWall();
          else if ( m_right ) placeRightWall();
          
          if ( m_bottom && m_bottom.isOpen && m_bottom.isValid ) m_bottom.removeTopWall();
          else if ( m_bottom ) placeBottomWall();
        }
      }
    }
    
    public function get defaultWallConfiguration():WallConfiguration
    {
      return m_defaultWallConfiguration;
    }
    
    public function get wallConfiguration():WallConfiguration
    {
      if ( m_defaultWallConfiguration.isStale )
      {
        m_wallConfiguration.top = m_defaultWallConfiguration.top;
        m_wallConfiguration.right = m_defaultWallConfiguration.right;
        m_wallConfiguration.bottom = m_defaultWallConfiguration.bottom;
        m_wallConfiguration.left = m_defaultWallConfiguration.left;
        
        m_wallConfiguration.tl = m_defaultWallConfiguration.tl;
        m_wallConfiguration.tr = m_defaultWallConfiguration.tr;
        m_wallConfiguration.br = m_defaultWallConfiguration.br;
        m_wallConfiguration.bl = m_defaultWallConfiguration.bl;
        
        m_defaultWallConfiguration.lock();
      }
      
      return m_wallConfiguration;
    }
    
    public function configure(wallChanges:Boolean = false, forLoad:Boolean = false):void
    {
      if ( wallChanges )
      {
        if (!forLoad)
        {
          if ( m_right ) m_defaultWallConfiguration.right = m_right.defaultWallConfiguration.left && ( m_right.isOpen || ( m_open && !m_right.isOpen ) );
          if ( m_bottom ) m_defaultWallConfiguration.bottom = m_bottom.defaultWallConfiguration.top && ( m_bottom.isOpen || ( m_open && !m_bottom.isOpen ) );
          if ( m_left ) m_defaultWallConfiguration.left = m_left.defaultWallConfiguration.right && ( m_left.isOpen || ( m_open && !m_left.isOpen ) );
          if ( m_top ) m_defaultWallConfiguration.top = m_top.defaultWallConfiguration.bottom && ( m_top.isOpen || ( m_open && !m_top.isOpen ) );
          
          if ( !this.wallConfiguration.isStale )
          {
            return;
          }
        }
        
        if ( m_left ) m_left.configure(m_valid && !m_left.isValid);
        if ( m_top ) m_top.configure(m_valid && !m_top.isValid);
        if ( m_right ) m_right.configure(m_valid && !m_right.isValid);
        if ( m_bottom ) m_bottom.configure(m_valid && !m_bottom.isValid);
      }
      else
      {
        this.wallConfiguration.lock();
      }
      
      var wallCount:uint = this.wallConfiguration.count;
      
      m_wallImage.texture = m_baseImage.texture;
      
      var a:Boolean = false;
      var b:Boolean = false;
      var c:Boolean = false;
      var d:Boolean = false;
      
      if ( wallCount == 4 )
      {
        m_wallImage.texture = TextureManager.Get("game", "wall_w4_c0_r0");
      }
      else if ( wallCount == 3 )
      {
        m_wallImage.texture = TextureManager.Get("game", "wall_w3_c0_r0");
        
        if ( !m_wallConfiguration.left )
        {
          m_wallImage.rotation = 0;
        }
        else if ( !m_wallConfiguration.top )
        {
          m_wallImage.rotation = Math.PI / 2;
        }
        else if ( !m_wallConfiguration.right )
        {
          m_wallImage.rotation = Math.PI;
        }
        else
        {
          m_wallImage.rotation = Math.PI / 2 * 3;
        }
      }
      else if ( wallCount == 2 )
      {
        if ( m_wallConfiguration.isSplit )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w2b_c0_r0");
          if ( m_wallConfiguration.left )
          {
            m_wallImage.rotation = Math.PI / 2;
          }
          else
          {
            m_wallImage.rotation = 0;
          }
        }
        else
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w2a_c0_r0");
          var cornerName:String = "wall_w2a_c0_r1";
          
          if ( m_wallConfiguration.top && m_wallConfiguration.left )
          {
            if ((m_right && m_right.wallConfiguration.bottom) || (m_bottom && m_bottom.wallConfiguration.right))
            {
              m_wallImage.texture = TextureManager.Get("game", "wall_w2a_c1_r0");
              cornerName = "wall_w2a_c1_r1";
            }
              
            if ( m_wallConfiguration.tl )
            {
              m_wallImage.texture = TextureManager.Get("game", cornerName);
            }
              
            m_wallImage.rotation = Math.PI / 2 * 3;
          }
          else if ( m_wallConfiguration.top && m_wallConfiguration.right )
          {
            if ((m_left && m_left.wallConfiguration.bottom) || (m_bottom && m_bottom.wallConfiguration.left))
            {
              m_wallImage.texture = TextureManager.Get("game", "wall_w2a_c1_r0");
              cornerName = "wall_w2a_c1_r1";
            }
              
            if ( m_wallConfiguration.tr )
            {
              m_wallImage.texture = TextureManager.Get("game", cornerName);
            }
              
            m_wallImage.rotation = 0;
          }
          else if ( m_wallConfiguration.bottom && m_wallConfiguration.right )
          {
            if ((m_left && m_left.wallConfiguration.top) || (m_top && m_top.wallConfiguration.left))
            {
              m_wallImage.texture = TextureManager.Get("game", "wall_w2a_c1_r0");
              cornerName = "wall_w2a_c1_r1";
            }
            
            if ( m_wallConfiguration.br )
            {
              m_wallImage.texture = TextureManager.Get("game", cornerName);
            }
              
            m_wallImage.rotation = Math.PI / 2;
          }
          else if ( m_wallConfiguration.bottom && m_wallConfiguration.left )
          {
            if ((m_right && m_right.wallConfiguration.top) || (m_top && m_top.wallConfiguration.right))
            {
              m_wallImage.texture = TextureManager.Get("game", "wall_w2a_c1_r0");
              cornerName = "wall_w2a_c1_r1";
            }
            
            if ( m_wallConfiguration.bl )
            {
              m_wallImage.texture = TextureManager.Get("game", cornerName);
            }
              
            m_wallImage.rotation = Math.PI;
          }
        }
      }
      else if ( wallCount == 1 )
      {
        m_wallImage.texture = TextureManager.Get("game", "wall_w1_c0_r0");
        
        a = false;
        b = false;
        
        if ( m_wallConfiguration.top )
        {
          a = ( m_left && m_left.wallConfiguration.bottom ) || ( m_bottom && m_bottom.wallConfiguration.left );
          b = ( m_right && m_right.wallConfiguration.bottom ) || ( m_bottom && m_bottom.wallConfiguration.right );
          
          m_wallImage.rotation = 0;
        }
        else if ( m_wallConfiguration.right )
        {
          a = ( m_top && m_top.wallConfiguration.left ) || ( m_left && m_left.wallConfiguration.top );
          b = ( m_bottom && m_bottom.wallConfiguration.left ) || ( m_left && m_left.wallConfiguration.bottom );
          
          m_wallImage.rotation = Math.PI / 2;
        }
        else if ( m_wallConfiguration.bottom )
        {
          a = ( m_right && m_right.wallConfiguration.top ) || ( m_top && m_top.wallConfiguration.right );
          b = ( m_left && m_left.wallConfiguration.top ) || ( m_top && m_top.wallConfiguration.left );
          
          m_wallImage.rotation = Math.PI;
        }
        else if ( m_wallConfiguration.left )
        {
          a = ( m_bottom && m_bottom.wallConfiguration.right ) || ( m_right && m_right.wallConfiguration.bottom );
          b = ( m_top && m_top.wallConfiguration.right ) || ( m_right && m_right.wallConfiguration.top );
          
          m_wallImage.rotation = Math.PI / 2 * 3;
        }
        
        if ( a && !b )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w1_c1a_r0");
        }
        else if ( !a && b )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w1_c1b_r0");
        }
        else if ( a && b )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w1_c2_r0");
        }
      }
      else
      {
        a = ( m_left && m_left.wallConfiguration.bottom ) || ( m_bottom && m_bottom.wallConfiguration.left );
        b = ( m_left && m_left.wallConfiguration.top ) || ( m_top && m_top.wallConfiguration.left );
        c = ( m_right && m_right.wallConfiguration.top ) || ( m_top && m_top.wallConfiguration.right );
        d = ( m_right && m_right.wallConfiguration.bottom ) || ( m_bottom && m_bottom.wallConfiguration.right );
        
        var cornerCount:uint = uint(a) + uint(b) + uint(c) + uint(d);
        
        if ( cornerCount == 4 )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w0_c4_r0");
        }
        else if ( cornerCount == 3 )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w0_c3_r0");
          
          if ( !d )
          {
            m_wallImage.rotation = 0;
          }
          else if ( !a )
          {
            m_wallImage.rotation = Math.PI / 2;
          }
          else if ( !b )
          {
            m_wallImage.rotation = Math.PI;
          }
          else
          {
            m_wallImage.rotation = Math.PI / 2 * 3;
          }
        }
        else if ( cornerCount == 2 )
        {
          if ( ( a && c ) || ( b && d ) )
          {
            m_wallImage.texture = TextureManager.Get("game", "wall_w0_c2b_r0");
            
            if ( a )
            {
              m_wallImage.rotation = 0;
            }
            else
            {
              m_wallImage.rotation = Math.PI / 2;
            }
          }
          else
          {
            m_wallImage.texture = TextureManager.Get("game", "wall_w0_c2a_r0");
            
            if ( a && b )
            {
              m_wallImage.rotation = 0;
            }
            else if ( b && c )
            {
              m_wallImage.rotation = Math.PI / 2;
            }
            else if ( c && d )
            {
              m_wallImage.rotation = Math.PI;
            }
            else
            {
              m_wallImage.rotation = Math.PI / 2 * 3;
            }
          }
        }
        else if ( cornerCount == 1 )
        {
          m_wallImage.texture = TextureManager.Get("game", "wall_w0_c1_r0");
          
          if ( a )
          {
            m_wallImage.rotation = 0;
          }
          else if ( b )
          {
            m_wallImage.rotation = Math.PI / 2;
          }
          else if ( c )
          {
            m_wallImage.rotation = Math.PI;
          }
          else
          {
            m_wallImage.rotation = Math.PI / 2 * 3;
          }
        }
      }
      
      if ( m_wallImage.texture == m_baseImage.texture && this.contains(m_wallImage) )
      {
        this.removeChild(m_wallImage);
      }
      else if ( m_wallImage.texture != m_baseImage.texture && !this.contains(m_wallImage) )
      {
        this.addChild(m_wallImage);
      }
    }
    
    public function placeLeftWall():void
    {
      if ( m_defaultWallConfiguration.left )
      {
        return;
      }
      
      m_defaultWallConfiguration.left = true;
      
      configure();
      
      if ( m_top ) m_top.configure();
      if ( m_bottom ) m_bottom.configure();
      if ( m_left ) m_left.configure(true);
    }
    
    public function removeLeftWall():void
    {
      if ( !m_valid || !m_open )
      {
        return;
      }
      
      if ( !m_defaultWallConfiguration.left )
      {
        return;
      }
      
      if ( !m_left || !m_left.isOpen || !m_left.isValid )
      {
        return;
      }
      
      m_defaultWallConfiguration.left = false;
      
      configure();

      if ( m_top ) m_top.configure();
      if ( m_bottom ) m_bottom.configure();
      if ( m_left ) m_left.configure(true);
    }
    
    public function placeTopWall():void
    {
      if ( m_defaultWallConfiguration.top )
      {
        return;
      }
      
      m_defaultWallConfiguration.top = true;
      
      configure();
      
      if ( m_left ) m_left.configure();
      if ( m_right ) m_right.configure();
      if ( m_top ) m_top.configure(true);
    }
    
    public function removeTopWall():void
    {
      if ( !m_valid || !m_open )
      {
        return;
      }
      
      if ( !m_defaultWallConfiguration.top )
      {
        return;
      }
      
      if ( !m_top || !m_top.isOpen || !m_top.isValid )
      {
        return;
      }
      
      m_defaultWallConfiguration.top = false;
      
      configure();
      
      if ( m_left ) m_left.configure();
      if ( m_right ) m_right.configure();
      if ( m_top ) m_top.configure(true);
    }
    
    public function placeRightWall():void
    {      
      if ( m_defaultWallConfiguration.right )
      {
        return;
      }
      
      m_defaultWallConfiguration.right = true;
      
      configure();
      
      if ( m_top ) m_top.configure();
      if ( m_bottom ) m_bottom.configure();
      if ( m_right ) m_right.configure(true);
    }
    
    public function removeRightWall():void
    {
      if ( !m_valid || !m_open )
      {
        return;
      }
      
      if ( !m_defaultWallConfiguration.right )
      {
        return;
      }
      
      if ( !m_right || !m_right.isOpen || !m_right.isValid )
      {
        return;
      }
      
      m_defaultWallConfiguration.right = false;
      
      configure();
      
      if ( m_top ) m_top.configure();
      if ( m_bottom ) m_bottom.configure();
      if ( m_right ) m_right.configure(true);
    }
    
    public function placeBottomWall():void
    {
      if ( m_defaultWallConfiguration.bottom )
      {
        return;
      }
      
      m_defaultWallConfiguration.bottom = true;
      
      configure();
      
      if ( m_left ) m_left.configure();
      if ( m_right ) m_right.configure();
      if ( m_bottom ) m_bottom.configure(true);
    }
    
    public function removeBottomWall():void
    {
      if ( !m_valid )
      {
        return;
      }
      
      if ( !m_defaultWallConfiguration.bottom )
      {
        return;
      }
      
      if ( !m_bottom || !m_bottom.isOpen || !m_bottom.isValid )
      {
        return;
      }
      
      m_defaultWallConfiguration.bottom = false;
      
      configure();
      
      if ( m_left ) m_left.configure();
      if ( m_right ) m_right.configure();
      if ( m_bottom ) m_bottom.configure(true);
    }
    
    public function set top(val:Tile):void
    {
      m_top = val;
      if ( m_top.bottom != this )
      {
        m_top.bottom = this;
      }
      
      if ( !m_top.isOpen && m_open )
      {
        m_defaultWallConfiguration.top = true;
        
        m_top.configure(true);
      }
      else
      {
        configure();
      }
    }
    
    public function set left(val:Tile):void
    {
      m_left = val;
      if ( m_left.right != this )
      {
        m_left.right = this;
      }
      
      if ( !m_left.isOpen && m_open )
      {
        m_defaultWallConfiguration.left = true;
        
        m_left.configure(true);
      }
      else
      {
        configure();
      }
    }
    
    public function set bottom(val:Tile):void
    {
      m_bottom = val;
      if ( m_bottom.top != this )
      {
        m_bottom.top = this;
      }
      
      if ( !m_bottom.isOpen && m_open )
      {
        m_defaultWallConfiguration.bottom = true;
        
        m_bottom.configure(true);
      }
      else
      {
        configure();
      }
    }
    
    public function set right(val:Tile):void
    {
      m_right = val;
      if ( m_right.left != this )
      {
        m_right.left = this;
      }
      
      if ( !m_right.isOpen && m_open )
      {
        m_defaultWallConfiguration.right = true;
        
        m_right.configure(true);
      }
      else
      {
        configure();
      }
    }
    
    public function get top():Tile
    {
      return m_top;
    }
    
    public function get left():Tile
    {
      return m_left;
    }
    
    public function get bottom():Tile
    {
      return m_bottom;
    }
    
    public function get right():Tile
    {
      return m_right;
    }
    
    public function get isOpen():Boolean
    {
      return m_open;
    }
    
    public function get isValid():Boolean
    {
      return m_valid;
    }
    
    public function get board():Board
    {
      return m_board;
    }
  }

}

class WallConfiguration
{
  private var m_top:Boolean = false;
  private var m_right:Boolean = false;
  private var m_bottom:Boolean = false;
  private var m_left:Boolean = false;
  
  private var m_tl:Boolean = false;
  private var m_tr:Boolean = false;
  private var m_br:Boolean = false;
  private var m_bl:Boolean = false;
  
  private var m_stale:Boolean = false;
  
  private var m_count:uint = 0;
  private var m_split:Boolean = false;
  
  public function WallConfiguration(top:Boolean = false, right:Boolean = false, bottom:Boolean = false, left:Boolean = false):void
  {
    m_top = top;
    m_right = right;
    m_bottom = bottom;
    m_left = left;
    
    m_count = uint(m_top) + uint(m_right) + uint(m_bottom) + uint(m_left);
    m_split = m_count == 2 && ( ( m_top && m_bottom ) || ( m_right && m_left ) );
  }
  
  public function compress():int
  {
    var ret:int = 0;
    if ( m_top )    ret |= ( 1 << 0 );
    if ( m_right )  ret |= ( 1 << 1 );
    if ( m_bottom ) ret |= ( 1 << 2 );
    if ( m_left )   ret |= ( 1 << 3 );
    if ( m_tl )     ret |= ( 1 << 4 );
    if ( m_tr )     ret |= ( 1 << 5 );
    if ( m_br )     ret |= ( 1 << 6 );
    if ( m_bl )     ret |= ( 1 << 7 );
    return ret;
  }
  
  public function decompress(store:int):void
  {
    if ( store & ( 1 << 0 ) ) m_top = true;
    if ( store & ( 1 << 1 ) ) m_right = true;
    if ( store & ( 1 << 2 ) ) m_bottom = true;
    if ( store & ( 1 << 3 ) ) m_left = true;
    if ( store & ( 1 << 4 ) ) m_tl = true;
    if ( store & ( 1 << 5 ) ) m_tr = true;
    if ( store & ( 1 << 6 ) ) m_br = true;
    if ( store & ( 1 << 7 ) ) m_bl = true;
    
    m_stale = true;
    
    verify();
  }
  
  public function clear():void
  {
    m_top = false;
    m_left = false;
    m_right = false;
    m_bottom = false;
    
    m_count = 0;
    m_split = false;
    m_stale = true;
  }
  
  public function verify():void
  {
    m_count = uint(m_top) + uint(m_right) + uint(m_bottom) + uint(m_left);
    m_split = m_count == 2 && ( ( m_top && m_bottom ) || ( m_right && m_left ) );
    
    if ( m_split || m_count != 2 )
    {
      m_bl = m_br = m_tl = m_tr = false;
    }
    
    if (m_bl && (!m_left || !m_bottom))
    {
      m_bl = false;
    }
    
    if (m_br && (!m_right || !m_bottom))
    {
      m_bl = false;
    }
    
    if (m_tl && (!m_left || !m_top))
    {
      m_bl = false;
    }
    
    if (m_tr && (!m_right || !m_top))
    {
      m_bl = false;
    }
  }
  
  public function get top():Boolean
  {
    return m_top;
  }
  
  public function set top(val:Boolean):void
  {
    if ( m_top != val )
    {
      m_stale = true;
    }
    m_top = val;
    
    if ( !m_top )
    {
      m_tl = false;
      m_tr = false;
    }
    
    verify();
  }
  
  public function get right():Boolean
  {
    return m_right;
  }
  
  public function set right(val:Boolean):void
  {
    if ( m_right != val )
    {
      m_stale = true;
    }
    m_right = val;
    
    if ( !m_right )
    {
      m_tr = false;
      m_br = false;
    }
    
    verify();
  }
  
  public function get bottom():Boolean
  {
    return m_bottom;
  }
  
  public function set bottom(val:Boolean):void
  {
    if ( m_bottom != val )
    {
      m_stale = true;
    }
    m_bottom = val;
    
    if ( !m_bottom )
    {
      m_bl = false;
      m_br = false;
    }
    
    verify();
  }
  
  public function get left():Boolean
  {
    return m_left;
  }
  
  public function set left(val:Boolean):void
  {
    if ( m_left != val )
    {
      m_stale = true;
    }
    m_left = val;
    
    if ( !m_left )
    {
      m_bl = false;
      m_tl = false;
    }
    
    verify();
  }
  
  public function get tl():Boolean
  {
    return m_tl;
  }
  
  public function set tl(val:Boolean):void
  {
    if (val != m_tl)
    {
      m_stale = true;
    }
    
    m_tl = val;
    if ( !m_top || !m_left )
    {
      m_tl = false;
    }
  }
  
  public function get tr():Boolean
  {
    return m_tr;
  }
  
  public function set tr(val:Boolean):void
  {
    if (val != m_tr)
    {
      m_stale = true;
    }
    
    m_tr = val;
    if ( !m_top || !m_right )
    {
      m_tr = false;
    }
  }
  
  public function get br():Boolean
  {
    return m_br;
  }
  
  public function set br(val:Boolean):void
  {
    if (val != m_br)
    {
      m_stale = true;
    }
    
    m_br = val;
    if ( !m_bottom || !m_right )
    {
      m_br = false;
    }
  }
  
  public function get bl():Boolean
  {
    return m_bl;
  }
  //TODO - Test a more complicated puzzle save and load, just got corners working, also need to remove override wall config as it's useless
  public function set bl(val:Boolean):void
  {
    if (val != m_bl)
    {
      m_stale = true;
    }
    
    m_bl = val;
    if ( !m_bottom || !m_left )
    {
      m_bl = false;
    }
  }
  
  public function get isStale():Boolean
  {
    return m_stale;
  }
  
  public function lock():void
  {
    if ( m_stale )
    {
      m_stale = false;
    }
  }
  
  public function get count():uint
  {
    return m_count;
  }
  
  public function get isSplit():Boolean
  {
    return m_split;
  }
  
  public function print():void
  {
    trace(m_top + "|" + m_right + "|" + m_bottom + "|" + m_left);
  }
}