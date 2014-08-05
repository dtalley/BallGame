package src.game 
{
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.utils.ByteArray;
  import src.game.controller.ControllerConfiguration;
  import src.game.controller.Main;
  import src.game.controller.PuzzleLoader;
  import src.game.controller.PuzzleResult;
  import src.game.controller.SplashWeb;
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
  import flash.events.Event;
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
    
    private var m_splash:SplashWeb;
    private var m_main:Main;
    private var m_puzzleLoader:PuzzleLoader;
    private var m_planner:Planner;
    private var m_simulator:Simulator;
    private var m_puzzleResult:PuzzleResult;
    
    public function ApplicationWeb() 
    {      
      
    }
    
    public function start():void
    {
      ConfigManager.load();
      
      m_splash = new SplashWeb();
      m_splash.addEventListener("assetsLoaded", this.configureMainAtlas);
      
      this.setController(m_splash, null);
      
      this.addEventListener(starling.events.Event.ENTER_FRAME, this.Update);
    }
    
    private function configureMainAtlas(e:Event = null):void
    {      
      var mainLoader:Loader = AssetManager.Get("assets/textures/hd/main.png") as Loader;
      var mainTexture:Texture = TextureManager.Get("assets/textures/hd/main.png");
      var mainAtlas:TextureAtlas = TextureManager.CreateAtlas("main", mainTexture);
      
      var atlasJson:ByteArray = AssetManager.Get("assets/textures/hd/main.json") as ByteArray;
      var json:String = atlasJson.readUTFBytes(atlasJson.length);
      
      var obj:Array = JSON.parse(json) as Array;
      obj.forEach(function(spr:Array, a:*, b:*):void {
        mainAtlas.addRegion(spr[0], new Rectangle(spr[1], spr[2], spr[3], spr[4]));
      });
      
      m_main = new Main();
      m_puzzleLoader = new PuzzleLoader();
      m_puzzleLoader.addEventListener("assetsLoaded", this.configureGameAtlas);
      m_planner = new Planner();
      m_simulator = new Simulator();
      m_puzzleResult = new PuzzleResult();
      this.setController(m_main, null);
    }
    
    private function configureGameAtlas(e:Event = null):void
    {
      var mainLoader:Loader = AssetManager.Get("assets/textures/hd/game.png") as Loader;
      var mainTexture:Texture = TextureManager.Get("assets/textures/hd/game.png");
      var mainAtlas:TextureAtlas = TextureManager.CreateAtlas("game", mainTexture);
      
      var atlasJson:ByteArray = AssetManager.Get("assets/textures/hd/game.json") as ByteArray;
      var json:String = atlasJson.readUTFBytes(atlasJson.length);
      
      var obj:Array = JSON.parse(json) as Array;
      obj.forEach(function(spr:Array, a:*, b:*):void {
        mainAtlas.addRegion(spr[0], new Rectangle(spr[1], spr[2], spr[3], spr[4]));
      });
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
      if (e.name == "main")
      {
        this.setController(m_main, e.configuration);
      }
      else if (e.name == "puzzleLoader")
      {
        this.setController(m_puzzleLoader, e.configuration);
      }
      else if (e.name == "planner")
      {
        this.setController(m_planner, e.configuration);
      }
      else if (e.name == "simulator")
      {
        this.setController(m_simulator, e.configuration);
      }
      else if (e.name == "puzzleResult")
      {
        this.setController(m_puzzleResult, e.configuration);
      }
    }
    
    public function Update(e:EnterFrameEvent):void
    {
      m_controller.Update(e.passedTime);
    }
  }

}