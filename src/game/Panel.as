package src.game 
{
  import flash.geom.Rectangle;
  import src.game.utils.ConfigManager;
  import src.game.utils.TextureManager;
	import starling.display.Sprite;
  import src.starling.extensions.Scale9Image;
  import starling.textures.TextureSmoothing;
	
	/**
   * ...
   * @author 
   */
  public class Panel extends Sprite 
  {
    private var m_background:Scale9Image;
    
    private var m_buttons:Vector.<PanelButton> = new Vector.<PanelButton>();
    
    private var m_tree:ButtonTree = null;
    
    public function Panel() 
    {
      m_background = new Scale9Image(TextureManager.Get("atlas", "panel_background"), new Rectangle(3, 3, 3, 3));
      this.addChild(m_background);
      m_background.width = ConfigManager.TILE_SIZE + 8;
      m_background.height = ( ConfigManager.TILE_SIZE * Board.rows ) + 8;
      m_background.smoothing = TextureSmoothing.NONE;
      
      for ( var i:int = 0; i < Board.rows; i++ )
      {
        var button:PanelButton = new PanelButton();
        this.addChild(button);
        button.y = 4 + ( i * ConfigManager.TILE_SIZE );
        button.x = 4;
        m_buttons.push(button);
      }
    }
    
    public function clearIcons():void
    {
      for ( var i:int = 0; i < m_buttons.length; i++ )
      {
        m_buttons[i].removeIcon();
      }
    }
    
    public function loadTree(tree:ButtonTree):void
    {
      if ( m_tree )
      {
        m_tree.unload();
      }
      
      m_tree = tree;
      m_tree.panel = this;
      
      for ( var i:int = 0; i < m_buttons.length; i++ )
      {
        if ( m_tree.count <= i )
        {
          m_buttons[i].removeIcon();
        }
        else
        {
          m_tree.getChild(i).load(m_buttons[i]);
        }
      }
      
      m_tree.activate();
    }
  }

}