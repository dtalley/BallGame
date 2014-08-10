package src.game 
{
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.utils.ByteArray;
  import src.game.controller.ControllerConfiguration;
  import src.game.controller.Editor;
  import src.game.event.ControllerEvent;
  import src.game.utils.ConfigManager;
  import starling.textures.Texture;
  import flash.geom.Rectangle;
  import src.game.controller.Controller;
  import src.game.controller.Planner;
  import src.game.controller.Simulator;
  import src.game.utils.AssetManager;
  import src.game.utils.TextureManager;
  import starling.display.Quad;
	import starling.display.Sprite;
  import starling.textures.TextureAtlas;
  import starling.utils.Color;
  import starling.events.Event;
  import starling.events.EnterFrameEvent;
	
	/**
   * ...
   * @author 
   */
  public class ApplicationEditor extends Sprite 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_controller:Controller = null;
    
    private var m_planner:Planner;
    private var m_simulator:Simulator;
    private var m_editor:Editor;
    
    public function ApplicationEditor() 
    {      
      
    }
    
    public function start():void
    {      
      this.configureMainAtlas();
    }
    
    private function configureMainAtlas():void
    {      
      TextureManager.ConfigureAtlas("game", "game");
      
      this.createBoard();
    }
    
    private function createBoard():void
    {
      m_board = new Board();
      this.addChild(m_board);
      m_board.x = Math.round(ConfigManager.TILE_SIZE / 4);
      m_board.y = ( stage.stageHeight / 2 ) - ( ( Board.rows * ConfigManager.TILE_SIZE ) / 2 );
      
      if ( m_board.x < m_board.y )
      {
        m_board.y = m_board.x;
      }
      else
      {
        m_board.x = m_board.y;
      }
      
      m_panel = new Panel();
      this.addChild(m_panel);
      m_panel.x = stage.stageWidth - m_panel.width - m_board.x;
      m_panel.y = m_board.y - 4;
      
      stageResized();
      
      m_planner = new Planner();
      m_simulator = new Simulator();
      m_editor = new Editor(m_board, m_panel);
      
      this.setController(m_editor, null);
      
      this.addEventListener(Event.ENTER_FRAME, this.Update);
      
      stage.addEventListener(Event.RESIZE, stageResized);
    }
    
    private function stageResized(e:Event = null):void
    {
      m_board.y = Math.round(( stage.stageHeight / 2 ) - ( ( Board.rows * ConfigManager.TILE_SIZE ) / 2 ));
      m_panel.x = stage.stageWidth - m_panel.width - m_board.x;
      m_panel.y = m_board.y - 4;
    }
    
    private function setController(controller:Controller, configuration:ControllerConfiguration):void
    {
      var previous:Controller = null;
      if ( m_controller )
      {
        previous = m_controller;
        m_controller.removeEventListener(ControllerEvent.CHANGE_CONTROLLER, this.changeController);
        
        m_controller.Deactivate();
      }
      
      m_controller = controller;
      
      m_controller.addEventListener(ControllerEvent.CHANGE_CONTROLLER, this.changeController);
      
      m_controller.Activate(configuration, previous);
    }
    
    private function changeController(e:ControllerEvent):void
    {
      if (e.name == "planner")
      {
        this.setController(m_planner, e.configuration);
      }
      else if (e.name == "simulator")
      {
        this.setController(m_simulator, e.configuration);
      }
      else if ( e.name == "editor" )
      {
        this.setController(m_editor, e.configuration);
      }
    }
    
    public function Update(e:EnterFrameEvent):void
    {
      m_controller.Update(e.passedTime);
    }
  }

}