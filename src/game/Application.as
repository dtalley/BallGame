package src.game 
{
  import flash.display.Bitmap;
  import flash.display.Loader;
  import src.game.controller.Editor;
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
  public class Application extends Sprite 
  {
    private var m_board:Board;
    private var m_panel:Panel;
    
    private var m_controller:Controller = null;
    
    private var m_planner:Planner;
    private var m_simulator:Simulator;
    private var m_editor:Editor;
    
    public function Application() 
    {      
      this.addEventListener(starling.events.Event.ADDED_TO_STAGE, this.initialize);
    }
    
    private function configureMainAtlas():void
    {      
      var mainLoader:Loader = AssetManager.Get("assets/textures/hd/atlas.png") as Loader;
      var mainTexture:Texture = TextureManager.Create("atlasTexture", mainLoader.content as Bitmap);
      var mainAtlas:TextureAtlas = TextureManager.CreateAtlas("atlas", mainTexture);
      
      /*mainAtlas.addRegion("grid_open",          new Rectangle(74 *  0, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_closed",        new Rectangle(74 *  1, 74 * 0, 74, 74));
      
      mainAtlas.addRegion("grid_w1",            new Rectangle(74 *  2, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_w1_c1a",        new Rectangle(74 *  6, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_w1_c1b",        new Rectangle(74 *  7, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_w1_c2",         new Rectangle(74 *  8, 74 * 0, 74, 74));
      
      mainAtlas.addRegion("grid_w2a",           new Rectangle(74 *  3, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_w2b",           new Rectangle(74 *  2, 74 * 1, 74, 74));
      mainAtlas.addRegion("grid_w2a_r",         new Rectangle(74 *  3, 74 * 1, 74, 74));
      mainAtlas.addRegion("grid_w2_c1",         new Rectangle(74 *  9, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_w2_c1_r",       new Rectangle(74 *  4, 74 * 1, 74, 74));
      
      mainAtlas.addRegion("grid_w3",            new Rectangle(74 *  4, 74 * 0, 74, 74));
      
      mainAtlas.addRegion("grid_w4",            new Rectangle(74 *  5, 74 * 0, 74, 74));
      
      mainAtlas.addRegion("grid_c1",            new Rectangle(74 * 10, 74 * 0, 74, 74));
      
      mainAtlas.addRegion("grid_c2a",           new Rectangle(74 * 11, 74 * 0, 74, 74));
      mainAtlas.addRegion("grid_c2b",           new Rectangle(74 * 11, 74 * 1, 74, 74));
      
      mainAtlas.addRegion("grid_c3",            new Rectangle(74 * 12, 74 * 0, 74, 74));
      
      mainAtlas.addRegion("grid_c4",            new Rectangle(74 * 12, 74 * 1, 74, 74));
      
      mainAtlas.addRegion("hi_wall",            new Rectangle(962, 0, 8, 82));
      mainAtlas.addRegion("hi_corner",          new Rectangle(970, 0, 30, 30));
      mainAtlas.addRegion("hi_center",          new Rectangle(970, 30, 34, 34));
      
      mainAtlas.addRegion("ball_purple",        new Rectangle(74 * 2, 74 * 2, 74, 74));
      mainAtlas.addRegion("ball_blue",          new Rectangle(74 * 3, 74 * 2, 74, 74));
      mainAtlas.addRegion("ball_red",           new Rectangle(74 * 4, 74 * 2, 74, 74));
      
      mainAtlas.addRegion("goal_purple",        new Rectangle(74 * 2, 74 * 3, 74, 74));
      mainAtlas.addRegion("goal_blue",          new Rectangle(74 * 3, 74 * 3, 74, 74));
      mainAtlas.addRegion("goal_red",           new Rectangle(74 * 4, 74 * 3, 74, 74));
      
      mainAtlas.addRegion("gadget_redirect",    new Rectangle(74 * 2, 74 * 4, 74, 74));
      mainAtlas.addRegion("gadget_dispurse",    new Rectangle(74 * 3, 74 * 4, 74, 74));
      
      mainAtlas.addRegion("panel",              new Rectangle(74 * 5, 74 * 1, 82, 82));
      
      mainAtlas.addRegion("panel_out",          new Rectangle(74 * 1, 74 * 2, 74, 74));
      mainAtlas.addRegion("panel_down",         new Rectangle(74 * 1, 74 * 3, 74, 74));
      mainAtlas.addRegion("panel_selected",     new Rectangle(74 * 1, 74 * 4, 74, 74));
      
      mainAtlas.addRegion("panel_icon_play",    new Rectangle(74 * 0, 74 * 2, 74, 74));
      mainAtlas.addRegion("panel_icon_right",   new Rectangle(74 * 0, 74 * 3, 74, 74));
      mainAtlas.addRegion("panel_icon_left",    new Rectangle(74 * 0, 74 * 4, 74, 74));
      mainAtlas.addRegion("panel_icon_ball",    new Rectangle(74 * 0, 74 * 5, 74, 74));
      mainAtlas.addRegion("panel_icon_reset",   new Rectangle(74 * 1, 74 * 5, 74, 74));
      mainAtlas.addRegion("panel_icon_dispurse",new Rectangle(74 * 2, 74 * 5, 74, 74));
      mainAtlas.addRegion("panel_icon_base",    new Rectangle(74 * 0, 74 * 6, 74, 74));
      mainAtlas.addRegion("panel_icon_edit",    new Rectangle(74 * 1, 74 * 6, 74, 74));
      mainAtlas.addRegion("panel_icon_goal",    new Rectangle(74 * 0, 74 * 7, 74, 74));
      mainAtlas.addRegion("panel_icon_clear",   new Rectangle(74 * 0, 74 * 8, 74, 74));*/
    }
    
    private function initialize(e:starling.events.Event):void
    {
      this.configureMainAtlas();
    }
    
    private function createBoard():void
    {
      m_board = new Board();
      this.addChild(m_board);
      m_board.x = ( stage.stageWidth / 2 ) - ( ( Board.columns * Board.tileSize ) / 2 );
      m_board.y = ( stage.stageHeight / 2 ) - ( ( Board.rows * Board.tileSize ) / 2 );
      
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
      m_editor = new Editor(m_board, m_panel);
      
      this.setController(m_editor);
      
      this.addEventListener(starling.events.Event.ENTER_FRAME, this.Update);
    }
    
    private function setController(controller:Controller):void
    {
      if ( m_controller )
      {
        m_controller.removeEventListener("startPlanner", this.startPlanner);
        m_controller.removeEventListener("startSimulator", this.startSimulator);
        m_controller.removeEventListener("startEditor", this.startEditor);
        
        m_controller.Deactivate();
      }
      
      m_controller = controller;
      
      m_controller.addEventListener("startPlanner", this.startPlanner);
      m_controller.addEventListener("startSimulator", this.startSimulator);
      m_controller.addEventListener("startEditor", this.startEditor);
      
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
    
    private function startEditor(e:flash.events.Event):void
    {
      this.setController(m_editor);
    }
    
    public function Update(e:starling.events.EnterFrameEvent):void
    {
      m_controller.Update(e.passedTime);
    }
  }

}