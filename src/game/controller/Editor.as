package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.geom.Point;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.gadget.Combine;
  import src.game.gadget.Expand;
  import src.game.gadget.Gadget;
  import src.game.gadget.Goal;
  import src.game.gadget.Phase;
  import src.game.Panel;
  import src.game.Tile;
  import src.game.utils.ConfigManager;
  import src.game.utils.TextureManager;
  import starling.display.Image;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.textures.TextureSmoothing;
	/**
   * ...
   * @author 
   */
  public class Editor extends EventDispatcher implements Controller 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_wall:Image;
    private var m_corner:Image;
    private var m_center:Image;
    
    private var m_tile:Tile;
    private var m_region:uint;
    
    private var m_tree:ButtonTree;
    
    private var m_baseEdit:ButtonTree;
    private var m_ballEdit:ButtonTree;
    private var m_goalEdit:ButtonTree;
    private var m_gadgetsEdit:ButtonTree;
    
    private var m_backToMain:ButtonTree;    
    private var m_phaseEdit:ButtonTree;
    private var m_combineEdit:ButtonTree;
    private var m_expandEdit:ButtonTree;
    
    private var m_load:ButtonTree;
    private var m_save:ButtonTree;
    private var m_clear:ButtonTree;
    private var m_play:ButtonTree;
    
    private var m_placingBall:Ball;
    private var m_placingGadget:Gadget;
    
    private var m_ignoreTile:Tile;
    private var m_holdingTile:Tile;
    
    private var m_holding:Boolean = false;
    private var m_moved:Boolean = false;
    private var m_accumulator:Number = 0;
    
    private var m_tiles:Vector.<Tile>;
    
    public function Editor(board:Board, panel:Panel) 
    {
      m_board = board;
      m_panel = panel;
      
      m_tiles = m_board.tiles;
      
      m_wall = new Image(TextureManager.Get("atlas", "ui_grid_wall"));
      m_corner = new Image(TextureManager.Get("atlas", "ui_grid_corner"));
      m_center = new Image(TextureManager.Get("atlas", "ui_grid_center"));
      
      m_wall.smoothing = TextureSmoothing.NONE;
      m_corner.smoothing = TextureSmoothing.NONE;
      m_center.smoothing = TextureSmoothing.NONE;
      
      m_board.addChild(m_wall);
      m_board.addChild(m_corner);
      m_board.addChild(m_center);
      
      m_wall.visible = false;
      m_corner.visible = false;
      m_center.visible = false;
      
      m_tree = new ButtonTree("root", 0);
      m_baseEdit = m_tree.createChild("grid", ButtonTree.SELECTABLE, true);
      m_ballEdit = m_tree.createChild("ball", ButtonTree.SELECTABLE);
      m_goalEdit = m_tree.createChild("goal", ButtonTree.SELECTABLE);
      
      m_gadgetsEdit = m_tree.createChild("gear", ButtonTree.PUSH);
      
      m_backToMain = m_gadgetsEdit.createChild("left", ButtonTree.POP);
      m_phaseEdit = m_gadgetsEdit.createChild("phase", ButtonTree.SELECTABLE);
      m_combineEdit = m_gadgetsEdit.createChild("combine", ButtonTree.SELECTABLE);
      m_expandEdit = m_gadgetsEdit.createChild("expand", ButtonTree.SELECTABLE);
      
      m_load = m_tree.createChild("load");
      m_save = m_tree.createChild("save");
      m_clear = m_tree.createChild("clear");
      m_play = m_tree.createChild("play");
      
      m_load.addEventListener("activated", this.loadActivated);
      m_save.addEventListener("activated", this.saveActivated);
      m_clear.addEventListener("activated", this.clearActivated);
      m_play.addEventListener("activated", this.playActivated);
    }
    
    private function loadActivated(e:Event):void
    {
      var file:File = new File();
      file.browseForOpen("Load Puzzle");
      file.addEventListener(Event.SELECT, loadFileSelected);
    }
    
    private function loadFileSelected(e:Event):void
    {
      var file:File = e.currentTarget as File;
      var fs:FileStream = new FileStream();
      fs.open(file, FileMode.READ);
      m_board.load(fs);
      fs.close();
    }
    
    private function saveActivated(e:Event):void
    {
      var file:File = new File();
      file.browseForSave("Save Puzzle");
      file.addEventListener(Event.SELECT, saveFileSelected);
    }
    
    private function saveFileSelected(e:Event):void
    {
      var file:File = e.currentTarget as File;
      var fs:FileStream = new FileStream();
      fs.open(file, FileMode.WRITE);
      m_board.save(fs);
      fs.close();
    }
    
    private function clearActivated(e:Event):void
    {
      m_board.clearTiles();
    }
    
    private function playActivated(e:Event):void
    {
      this.dispatchEvent(new Event("startPlanner"));
    }
    
    public function Update(elapsed:Number):void
    {
      if ( m_holding )
      {
        m_accumulator += elapsed;
        if ( m_accumulator > 1 )
        {
          m_holdingTile.clearGadget();
          m_holdingTile = null;
          m_holding = false;
        }
      }
    }
    
    public function Activate():void
    {
      m_board.addEventListener(TouchEvent.TOUCH, this.boardTouched);
      
      m_panel.loadTree(m_tree);
      
      var count:uint = m_tiles.length;
      for ( var i:uint = 0; i < count; i++ )
      {
        m_tiles[i].clearPlan();
        m_tiles[i].reset();
      }
    }
    
    private function boardTouched(e:TouchEvent):void
    {
      var touch:Touch = e.touches[0];
      var position:Point = new Point(touch.globalX - m_board.x, touch.globalY - m_board.y);
      var tile:Tile = m_board.getTileAt(position.x, position.y);
      
      if ( m_baseEdit.isSelected )
      {
        m_holdingTile = null;
        m_holding = false;
        handleBaseEdit(tile, touch.phase, position);
      }
      else if (m_ballEdit.isSelected )
      {
        m_holdingTile = null;
        m_holding = false;
        handleBallEdit(tile, touch.phase);
      }
      else if ( m_goalEdit.isSelected )
      {
        handleGadgetEdit(tile, touch.phase, Goal);
      }
      else if ( m_phaseEdit.isSelected )
      {
        handleGadgetEdit(tile, touch.phase, Phase);
      }
      else if ( m_combineEdit.isSelected )
      {
        handleGadgetEdit(tile, touch.phase, Combine);
      }
      else if ( m_expandEdit.isSelected )
      {
        handleGadgetEdit(tile, touch.phase, Expand);
      }
    }
    
    private function handleGadgetEdit(tile:Tile, phase:String, type:Class):void
    {
      if ( !m_placingGadget || !(m_placingGadget is type) )
      {
        if ( m_placingGadget )
        {
          m_placingGadget.removeFromTile();
        }
        m_placingGadget = new type();
      }
      
      if ( phase == "hover" && ( !tile.hasGadget || tile.gadget != m_placingGadget ) )
      {
        m_placingGadget.removeFromTile();
      }
      
      if ( !tile || !tile.isOpen || m_ignoreTile == tile )
      {
        return;
      }
      
      m_ignoreTile = null;
      
      if ( phase === "hover" )
      {        
        if ( !tile.hasGadget )
        {
          m_placingGadget.tile = tile;
        }
      }
      else if ( phase === "began" )
      {
        m_moved = false;
        m_holdingTile = tile;
        if ( !tile.hasGadget )
        {
          m_placingGadget.tile = tile;
        }
        else if( tile.gadget != m_placingGadget )
        {
          m_accumulator = 0;
          m_holding = true;
        }
      }
      else if ( phase === "moved" )
      {
        if ( tile != m_holdingTile && !tile.hasGadget && m_holdingTile.hasGadget )
        {
          m_holdingTile.gadget.tile = tile;
          m_holdingTile = tile;
          m_holding = false;
          m_moved = true;
        }
      }
      else if( phase === "ended" )
      {
        m_holdingTile = null;
        m_holding = false;
        if ( tile.hasGadget )
        {
          if ( tile.gadget == m_placingGadget )
          {
            m_placingGadget = new type();
          }
          else if( !m_moved )
          {
            var gadget:Gadget = tile.gadget;
            gadget.tap();
          }
        }
      }
    }
    
    private function handleBallEdit(tile:Tile, phase:String):void
    {
      if ( !m_placingBall )
      {
        m_placingBall = new Ball();
        m_board.addBall(m_placingBall);
      }
      
      if ( tile && m_placingBall.tile != tile )
      {
        m_placingBall.removeFromTile();
      }
      
      if ( !tile || !tile.isOpen || m_ignoreTile == tile )
      {
        return;
      }
      
      m_ignoreTile = null;
        
      if ( phase === "hover" )
      {        
        if ( !tile.hasBall )
        {
          m_placingBall.tile = tile;
        }
      }
      else if ( phase === "began" )
      {
        var ball:Ball = tile.getBall(0);
        if ( ball == m_placingBall )
        {
          m_placingBall = new Ball();
          m_board.addBall(m_placingBall);
        }
        else if ( ball )
        {          
          if ( ball.type == Ball.PURPLE )
          {
            ball.type = Ball.BLUE;
          }
          else if ( ball.type == Ball.BLUE )
          {
            ball.type = Ball.RED;
          }
          else
          {
            ball.removeFromTile();
            m_board.removeBall(ball);
            m_ignoreTile = tile;
          }
        }
      }
    }
    
    private function handleBaseEdit(tile:Tile, phase:String, position:Point):void
    {      
      if ( !tile || !tile.isValid )
      {
        m_wall.visible = false;
        m_corner.visible = false;
        m_center.visible = false;
      
        return;
      }
      
      position.x -= tile.x;
      position.y -= tile.y;
      
      var region:uint = tile.getRegion(position.x, position.y);
      
      if ( phase === "hover" )
      {                
        m_wall.visible = false;
        m_corner.visible = false;
        m_center.visible = false;
      
        if ( region == Tile.CENTER )
        {          
          if ( tile.hasBall || tile.hasGadget )
          {
            return;
          }
          m_center.visible = true;
          m_center.x = tile.x + ( ConfigManager.TILE_SIZE / 2 ) - ( m_center.width / 2 );
          m_center.y = tile.y + ( ConfigManager.TILE_SIZE / 2 ) - ( m_center.height / 2 );
          return;
        }
        else if ( !tile.isOpen )
        {
          return;
        }
        
        if ( region == Tile.L_WALL )
        {
          if ( tile.left && !tile.left.isOpen )
          {
            return;
          }
          
          m_wall.visible = true;
          m_wall.x = tile.x - 4;
          m_wall.y = tile.y - 4;
          m_wall.rotation = 0;
          return;
        }
        else if ( region == Tile.T_WALL )
        {
          if ( tile.top && !tile.top.isOpen )
          {
            return;
          }
          
          m_wall.visible = true;
          m_wall.x = tile.x + ConfigManager.TILE_SIZE + 4;
          m_wall.y = tile.y - 4;
          m_wall.rotation = Math.PI / 2;
          return;
        }
        else if ( region == Tile.R_WALL )
        {
          if ( tile.right && !tile.right.isOpen )
          {
            return;
          }
          
          m_wall.visible = true;
          m_wall.x = tile.x + ConfigManager.TILE_SIZE + 4;
          m_wall.y = tile.y + ConfigManager.TILE_SIZE + 4;
          m_wall.rotation = Math.PI;
          return;
        }
        else if ( region == Tile.B_WALL )
        {
          if ( tile.bottom && !tile.bottom.isOpen )
          {
            return;
          }
          
          m_wall.visible = true;
          m_wall.x = tile.x - 4;
          m_wall.y = tile.y + ConfigManager.TILE_SIZE + 4;
          m_wall.rotation = Math.PI / 2 * 3;
          return;
        }
        
        if ( tile.wallConfiguration.count != 2 || tile.wallConfiguration.isSplit )
        {
          return;
        }
        if ( region == Tile.TL_CORNER )
        {
          if ( !tile.wallConfiguration.left || !tile.wallConfiguration.top )
          {
            return;
          }
          
          m_corner.visible = true;
          m_corner.x = tile.x + 6;
          m_corner.y = tile.y + 6;
          m_corner.rotation = 0;
        }
        else if ( region == Tile.TR_CORNER )
        {
          if ( !tile.wallConfiguration.right || !tile.wallConfiguration.top )
          {
            return;
          }
          
          m_corner.visible = true;
          m_corner.x = tile.x + ConfigManager.TILE_SIZE - 6;
          m_corner.y = tile.y + 6;
          m_corner.rotation = Math.PI / 2;
        } 
        else if ( region == Tile.BR_CORNER )
        {
          if ( !tile.wallConfiguration.right || !tile.wallConfiguration.bottom )
          {
            return;
          }
          
          m_corner.visible = true;
          m_corner.x = tile.x + ConfigManager.TILE_SIZE - 6;
          m_corner.y = tile.y + ConfigManager.TILE_SIZE - 6;
          m_corner.rotation = Math.PI;
        } 
        else if ( region == Tile.BL_CORNER )
        {
          if ( !tile.wallConfiguration.left || !tile.wallConfiguration.bottom )
          {
            return;
          }
          
          m_corner.visible = true;
          m_corner.x = tile.x + 6;
          m_corner.y = tile.y + ConfigManager.TILE_SIZE - 6;
          m_corner.rotation = Math.PI / 2 * 3;
        }
      }
      else if( phase === "began" )
      {        
        if ( region == Tile.CENTER && m_center.visible )
        {
          if ( tile.isOpen )
          {
            tile.close();
          }
          else
          {
            tile.open();
          }
        }
        
        if ( !tile.isOpen )
        {
          return;
        }
        
        if ( region == Tile.L_WALL )
        {
          if ( tile.wallConfiguration.left )
          {
            tile.removeLeftWall();
          }
          else
          {
            tile.placeLeftWall();
          }
        }
        else if ( region == Tile.R_WALL )
        {
          if ( tile.right )
          {
            if ( tile.right.wallConfiguration.left )
            {
              tile.right.removeLeftWall();
            }
            else
            {
              tile.right.placeLeftWall();
            }
          }
        }
        else if ( region == Tile.T_WALL )
        {
          if ( tile.wallConfiguration.top )
          {
            tile.removeTopWall();
          }
          else
          {
            tile.placeTopWall();
          }
        }
        else if ( region == Tile.B_WALL )
        {
          if ( tile.bottom )
          {
            if ( tile.bottom.wallConfiguration.top )
            {
              tile.bottom.removeTopWall();
            }
            else
            {
              tile.bottom.placeTopWall();
            }
          }
        }
        else if (region == Tile.TL_CORNER )
        {
          tile.defaultWallConfiguration.tl = !tile.defaultWallConfiguration.tl;
          tile.configure();
        }
        else if (region == Tile.TR_CORNER )
        {
          tile.defaultWallConfiguration.tr = !tile.defaultWallConfiguration.tr;
          tile.configure();
        }
        else if (region == Tile.BR_CORNER )
        {
          tile.defaultWallConfiguration.br = !tile.defaultWallConfiguration.br;
          tile.configure();
        }
        else if (region == Tile.BL_CORNER )
        {
          tile.defaultWallConfiguration.bl = !tile.defaultWallConfiguration.bl;
          tile.configure();
        }
      }
    }
    
    public function Deactivate():void
    {
      var count:uint = m_tiles.length;
      for ( var i:uint = 0; i < count; i++ )
      {
        m_tiles[i].lockDefault();
      }
      
      m_board.removeEventListener(TouchEvent.TOUCH, this.boardTouched);
      
      m_board.removeBall(m_placingBall);
      m_placingBall = null;
    }
  }

}