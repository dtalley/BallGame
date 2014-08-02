package src.game 
{
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.utils.ByteArray;
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
  import flash.events.Event;
  import starling.textures.TextureAtlas;
  import starling.utils.Color;
  import starling.events.Event;
  import starling.events.EnterFrameEvent;
	
	/**
   * ...
   * @author 
   */
  public class ApplicationWeb extends Sprite 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_controller:Controller = null;
    
    private var m_planner:Planner;
    private var m_simulator:Simulator;
    
    public function ApplicationWeb() 
    {      
      
    }
    
    public function start():void
    {
      ConfigManager.load();
      
      this.configureMainAtlas();
    }
    
    private function configureMainAtlas():void
    {      
      var mainLoader:Loader = AssetManager.Get("assets/textures/hd/atlas.png") as Loader;
      var mainTexture:Texture = TextureManager.Get("assets/textures/hd/atlas.png");
      var mainAtlas:TextureAtlas = TextureManager.CreateAtlas("atlas", mainTexture);
      
      var atlasJson:ByteArray = AssetManager.Get("assets/textures/hd/atlas.json") as ByteArray;
      var json:String = atlasJson.readUTFBytes(atlasJson.length);
      
      var obj:Array = JSON.parse(json) as Array;
      obj.forEach(function(spr:Array, a:*, b:*):void {
        mainAtlas.addRegion(spr[0], new Rectangle(spr[1], spr[2], spr[3], spr[4]));
      });
      
      this.createBoard();
    }
    
    private function createBoard():void
    {
      m_board = new Board();
      this.addChild(m_board);
      m_board.x = ( stage.stageWidth / 2 ) - ( ( Board.columns * ConfigManager.TILE_SIZE ) / 2 );
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
      
      m_planner = new Planner(m_board, m_panel);
      m_simulator = new Simulator(m_board, m_panel);
      
      this.setController(m_planner);
      
      this.addEventListener(starling.events.Event.ENTER_FRAME, this.Update);
    }
    
    private function setController(controller:Controller):void
    {
      if ( m_controller )
      {
        m_controller.removeEventListener("startPlanner", this.startPlanner);
        m_controller.removeEventListener("startSimulator", this.startSimulator);
        
        m_controller.Deactivate();
      }
      
      m_controller = controller;
      
      m_controller.addEventListener("startPlanner", this.startPlanner);
      m_controller.addEventListener("startSimulator", this.startSimulator);
      
      m_controller.Activate();
    }
    
    private function startPlanner(e:flash.events.Event):void
    {
      this.setController(m_planner);
    }
    
    private function startSimulator(e:flash.events.Event):void
    {
      this.setController(m_simulator);
    }
    
    public function Update(e:starling.events.EnterFrameEvent):void
    {
      m_controller.Update(e.passedTime);
    }
  }

}