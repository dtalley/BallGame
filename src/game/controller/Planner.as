package src.game.controller 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.utils.ByteArray;
  import src.game.Ball;
  import src.game.Board;
  import src.game.ButtonTree;
  import src.game.event.ControllerEvent;
  import src.game.gadget.Dispurse;
  import src.game.gadget.Gadget;
  import src.game.gadget.Rally;
  import src.game.gadget.Redirect;
  import src.game.gadget.Reverse;
  import src.game.Panel;
  import src.game.PuzzleConfiguration;
  import src.game.Tile;
  import src.game.utils.AssetManager;
  import src.game.utils.ConfigManager;
  import starling.core.Starling;
  import starling.events.Touch;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   * 
   */
  public class Planner extends EventDispatcher implements Controller
  {
    private static var s_gameAssetsLoaded:Boolean = false;
    
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_tree:ButtonTree;
    
    private var m_selectedBall:Ball;
    
    private var m_tiles:Vector.<Tile>;
    private var m_balls:Vector.<Ball>;
    
    private var m_edit:ButtonTree;
    
    private var m_reverse:ButtonTree;
    private var m_dispurse:ButtonTree;
    private var m_rally:ButtonTree;
    private var m_redirect:ButtonTree;
    
    private var m_placingGadget:Gadget;
    
    private var m_holding:Boolean = false;
    private var m_holdTile:Tile;
    private var m_accumulator:Number = 0;
    
    private var m_moved:Boolean = false;
    
    private var m_puzzleToLoad:String = null;
    
    private var m_puzzleConfiguration:PuzzleConfiguration = new PuzzleConfiguration();
    
    public function Planner() 
    {      
      m_tree = new ButtonTree("root", 0);      
      m_reverse = new ButtonTree("reverse", ButtonTree.SELECTABLE);
      m_dispurse = new ButtonTree("dispurse", ButtonTree.SELECTABLE);
      m_rally = new ButtonTree("rally", ButtonTree.SELECTABLE);
      m_redirect = new ButtonTree("redirect", ButtonTree.SELECTABLE);
       
      m_edit = new ButtonTree("edit", ButtonTree.NORMAL);
      m_edit.addEventListener("activated", this.editActivated);
    }
    
    private function editActivated(e:Event):void
    {
      this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "editor"));
    }
    
    public function Update(elapsed:Number):void
    {
      if ( !m_holding || !m_holdTile )
      {
        return;
      }
      
      m_accumulator += elapsed;
      
      if ( m_accumulator >= 1 )
      {
        if ( m_holdTile.hasGadget && !m_holdTile.hasDefaultGadget && !m_holdTile.gadget.isPersistent )
        {
          m_holdTile.clearGadget();
        }
      }
    }
    
    public function Activate(configuration:ControllerConfiguration, previous:Controller):void
    {
      if (configuration is PlannerConfiguration)
      {
        var plannerConfiguration:PlannerConfiguration = configuration as PlannerConfiguration;
        
        m_puzzleConfiguration.copy(plannerConfiguration.puzzleConfiguration);
        
        m_board = plannerConfiguration.board;
        m_panel = plannerConfiguration.panel;
        
        m_tiles = m_board.tiles;
        m_balls = m_board.balls;
        
        m_tree.clearChildren();
        
        if (ConfigManager.ENVIRONMENT == ConfigManager.ENVIRONMENT_EDITOR)
        {
          m_tree.addChild(m_edit);
        }
        
        if (m_puzzleConfiguration.isEnabled(Reverse)) m_tree.addChild(m_reverse);        
        if (m_puzzleConfiguration.isEnabled(Rally)) m_tree.addChild(m_rally);
        if (m_puzzleConfiguration.isEnabled(Dispurse)) m_tree.addChild(m_dispurse);
        if (m_puzzleConfiguration.isEnabled(Redirect)) m_tree.addChild(m_redirect);
        
        activateBoard();
      }
    }
    
    private function activateBoard():void
    {
      Starling.current.stage.addChild(m_board);
      Starling.current.stage.addChild(m_panel);
      
      m_board.addEventListener(TouchEvent.TOUCH, this.boardTouched);
      
      m_panel.loadTree(m_tree);
      
      var count:uint = m_tiles.length;
      for ( var i:uint = 0; i < count; i++ )
      {
        m_tiles[i].reset();
      }
      for ( i = 0; i < count; i++ )
      {
        m_tiles[i].resetPlan();
      }
      
      count = m_balls.length;
      for ( i = 0; i < count; i++ )
      {
        m_balls[i].reset();
      }
      
      m_board.prune();
      
      m_selectedBall = null;
    }
    
    private function boardTouched(e:TouchEvent):void
    {
      var touch:Touch = e.touches[0];
      var phase:String = touch.phase;      
      var position:Point = new Point(touch.globalX - m_board.x, touch.globalY - m_board.y);
      var tile:Tile = m_board.getTileAt(position.x, position.y);
      
      if ( phase == "ended" )
      {
        m_holding = false;
        m_holdTile = null;
      }
      
      if ( m_holdTile == tile )
      {
        return;
      }
      
      if ( phase == "began" )
      {
        if ( tile.hasGadget && tile.gadget.isMoveable )
        {
          m_holding = true;
          m_holdTile = tile;
          m_accumulator = 0;
        }
        
        m_selectedBall = null;
        if ( tile.hasBall )
        {
          var ball:Ball = tile.getBall(0);
          if ( !m_selectedBall && ball.direction.length == 0 )
          {
            m_selectedBall = ball;
          }
          return;
        }
      }
      else if ( phase == "moved" )
      {
        if ( m_selectedBall )
        {
          //TODO - Display direction ball will go
        }
        else if ( m_holdTile )
        {
          if ( m_holdTile != tile && !tile.hasGadget && !tile.hasBall && tile.isOpen && tile.isValid && m_holdTile.hasGadget )
          {
            m_holding = false;
            m_holdTile.gadget.tile = tile;
            m_holdTile = tile;
          }
        }
        
        m_moved = true;
      }
      else if ( phase == "ended" )
      {
        if ( m_selectedBall && tile != m_selectedBall.tile )
        {
          var relativePosition:Point = new Point(touch.globalX - m_board.x, touch.globalY - m_board.y);
          relativePosition.x -= m_selectedBall.tile.x;
          relativePosition.y -= m_selectedBall.tile.y;
          
          if ( Math.abs(relativePosition.x) > Math.abs(relativePosition.y) )
          {
            m_selectedBall.direction = new Point(relativePosition.x / Math.abs(relativePosition.x), 0);
          }
          else
          {
            m_selectedBall.direction = new Point(0, relativePosition.y / Math.abs(relativePosition.y));
          }
          
          m_selectedBall.calculateTarget();
          if ( m_selectedBall.direction.length == 0 )
          {
            m_selectedBall = null;
            return;
          }
          
          this.dispatchEvent(new ControllerEvent(ControllerEvent.CHANGE_CONTROLLER, "simulator", new SimulatorConfiguration(m_board, m_panel, m_puzzleConfiguration)));
          return;
        }
        
        if (tile.hasGadget && !m_moved)
        {
          tile.gadget.planTap();
        }
        
        m_moved = false;
      }
      
      if ( m_reverse.isSelected )
      {
        placeGadget(tile, position, phase, Reverse);
        return;
      }
      else if ( m_dispurse.isSelected )
      {
        placeGadget(tile, position, phase, Dispurse);
        return;
      }
      else if ( m_rally.isSelected )
      {
        placeGadget(tile, position, phase, Rally);
        return;
      }
      else if ( m_redirect.isSelected )
      {
        placeGadget(tile, position, phase, Redirect);
        return;
      }
    }
    
    private function placeGadget(tile:Tile, position:Point, phase:String, type:Class):void
    {
      if ( !m_placingGadget || !(m_placingGadget is type) )
      {
        m_placingGadget = new type();
      }
      
      if ( !tile.hasGadget || tile.gadget != m_placingGadget )
      {
        m_placingGadget.removeFromTile();
      }
      
      if ( !tile || !tile.isOpen || tile.hasBall )
      {
        return;
      }
      
      if ( phase === "hover" )
      {        
        if ( !tile.hasGadget )
        {
          tile.addGadget(m_placingGadget);
        }
      }
      else if ( phase === "ended" )
      {
        var gadget:Gadget = tile.gadget;
        if ( gadget == m_placingGadget )
        {
          m_placingGadget = new type();
        }
      }
    }
    
    public function Deactivate():void
    {
      var count:uint = m_tiles.length;
      for ( var i:uint = 0; i < count; i++ )
      {
        m_tiles[i].lockPlan();
      }
      
      m_selectedBall = null;
      m_board.removeEventListener(TouchEvent.TOUCH, this.boardTouched);
    }
  }

}