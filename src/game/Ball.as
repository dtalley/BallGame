package src.game 
{
  import flash.geom.Point;
  import src.game.utils.TextureManager;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.textures.TextureSmoothing;
	
	/**
   * ...
   * @author 
   */
  public class Ball extends Sprite 
  {
    public static const BLUE:uint = 0;
    public static const RED:uint = 1;
    public static const GREEN:uint = 2;
    public static const PURPLE:uint = 3;
    public static const YELLOW:uint = 4;
    public static const CYAN:uint = 5;
    public static const WHITE:uint = 6;
    
    private var m_base:Image;
    
    private var m_type:uint;
    
    private var m_tile:Tile = null;
    private var m_target:Tile = null;
    
    private var m_direction:Point = new Point();
    
    public function Ball(type:uint = RED) 
    {
      this.touchable = false;
      m_type = type;
      configure();
      this.addChild(m_base);
      m_base.smoothing = TextureSmoothing.NONE;
      
      this.visible = false;
    }
    
    private function configure():void
    {
      if (!m_base)
      {
        m_base = new Image(TextureManager.Get("atlas", "ball_red"));
      }
      
      if ( m_type == PURPLE )
      {
        m_base.texture = TextureManager.Get("atlas", "ball_purple");
      }
      else if ( m_type == BLUE )
      {
        m_base.texture = TextureManager.Get("atlas", "ball_blue");
      }
      else if ( m_type == RED )
      {
        m_base.texture = TextureManager.Get("atlas", "ball_red");
      }
      else if ( m_type == GREEN )
      {
        m_base.texture = TextureManager.Get("atlas", "ball_green");
      }
      else if ( m_type == YELLOW )
      {
        m_base.texture = TextureManager.Get("atlas", "ball_yellow");
      }
      else if ( m_type == CYAN )
      {
        m_base.texture = TextureManager.Get("atlas", "ball_cyan");
      }
    }
    
    public function set tile(val:Tile):void
    {
      if ( m_tile )
      {
        m_tile.removeBall(this);
      }
      
      m_tile = val;
      m_tile.addBall(this);
      this.x = m_tile.x;
      this.y = m_tile.y;
      this.visible = m_tile !== null;
    }
    
    public function get tile():Tile
    {
      return m_tile;
    }
    
    public function reset():void
    {
      m_direction.x = m_direction.y = 0;
    }
    
    public function removeFromTile():void
    {
      if ( m_tile )
      {
        m_tile.removeBall(this);
        m_tile = null;
        this.visible = false;
      }
    }
    
    public function calculateTarget():void
    {
      m_target = null;
      
      if ( !m_tile )
      {
        return;
      }
      
      if ( m_direction.length > 0 && m_tile.gadget )
      {
        m_tile.gadget.act(this, 1);
      }
      
      if ( m_direction.x < 0 )
      {        
        if ( !m_tile.left || m_tile.wallConfiguration.left || m_tile.left.wallConfiguration.right )
        {
          m_direction.x = 0;
          
          if ( m_tile.wallConfiguration.bl )
          {
            m_direction.y = -1;
            
            this.calculateTarget();
          }
          else if ( m_tile.wallConfiguration.tl )
          {
            m_direction.y = 1;
            
            this.calculateTarget();
          }
          
          return;
        }
        
        m_target = m_tile.left;
      }
      else if ( m_direction.x > 0 )
      {
        if ( !m_tile.right || m_tile.wallConfiguration.right || m_tile.right.wallConfiguration.left )
        {
          m_direction.x = 0;
          
          if ( m_tile.wallConfiguration.br )
          {
            m_direction.y = -1;
            
            this.calculateTarget();
          }
          else if ( m_tile.wallConfiguration.tr )
          {
            m_direction.y = 1;
            
            this.calculateTarget();
          }
          
          return;
        }
        
        m_target = m_tile.right;
      }
      else if ( m_direction.y < 0 )
      {
        if ( !m_tile.top || m_tile.wallConfiguration.top || m_tile.top.wallConfiguration.bottom )
        {
          m_direction.y = 0;
          
          if ( m_tile.wallConfiguration.tr )
          {
            m_direction.x = -1;
            
            this.calculateTarget();
          }
          else if ( m_tile.wallConfiguration.tl )
          {
            m_direction.x = 1;
            
            this.calculateTarget();
          }
          
          return;
        }
        
        m_target = m_tile.top;
      }
      else if ( m_direction.y > 0 )
      {
        if ( !m_tile.bottom || m_tile.wallConfiguration.bottom || m_tile.bottom.wallConfiguration.top )
        {
          m_direction.y = 0;
          
          if ( m_tile.wallConfiguration.br )
          {
            m_direction.x = -1;
            
            this.calculateTarget();
          }
          else if ( m_tile.wallConfiguration.bl )
          {
            m_direction.x = 1;
            
            this.calculateTarget();
          }
          
          return;
        }
        
        m_target = m_tile.bottom;
      }
      
      if ( m_target && m_target.hasGadget )
      {
        m_target.gadget.permit(this);
      }
    }
    
    public function moveFromSourceToTarget(percent:Number):void
    {
      if ( m_tile == null )
      {
        return;
      }
      
      if ( m_target == null )
      {
        this.x = m_tile.x;
        this.y = m_tile.y;
        return;
      }
      
      var xDiff:Number = ( m_target.x - m_tile.x ) * percent;
      var yDiff:Number = ( m_target.y - m_tile.y ) * percent;
      
      this.x = m_tile.x + xDiff;
      this.y = m_tile.y + yDiff;
      
      if ( m_tile.hasGadget )
      {
        m_tile.gadget.act(this, percent);
      }
    }
    
    public function set target(val:Tile):void
    {
      m_target = val;
    }
    
    public function get target():Tile
    {
      return m_target;
    }
    
    public function set type(val:uint):void
    {
      m_type = val;
      configure();
    }
    
    public function get type():uint
    {
      return m_type;
    }
    
    public function get direction():Point
    {
      return m_direction;
    }
    
    public function set direction(val:Point):void
    {
      m_direction = val;
    }
  }

}