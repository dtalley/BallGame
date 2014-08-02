package src.game.utils 
{
  import flash.utils.ByteArray;
	/**
   * ...
   * @author 
   */
  public class ConfigManager 
  {
    private static var s_environmentSet:Boolean = false;
    
    private static var s_tileSize:uint;
    private static var s_padding:uint;
    private static var s_environment:uint;
    
    public static function load():void
    {
      var configJson:ByteArray = null;
      
      if (s_environment == ENVIRONMENT_EDITOR)
      {
        configJson = AssetManager.Get("assets/config_editor.json") as ByteArray;
      }
      else if (s_environment == ENVIRONMENT_WEB)
      {
        configJson = AssetManager.Get("assets/config_web.json") as ByteArray;  
      }
      else
      {
        throw new Error("Could not load configuration file.");
      }
      
      var json:String = configJson.readUTFBytes(configJson.length);
      
      var obj:Object = JSON.parse(json) as Object;
      
      s_tileSize = parseInt(obj.tileSize);
      s_padding = parseInt(obj.padding);
    }
    
    public static function get TILE_SIZE():uint
    {
      return s_tileSize;
    }
    
    public static function get PADDING():uint
    {
      return s_padding;
    }
    
    public static function get ENVIRONMENT():uint
    {
      return s_environment;
    }
    
    public static function set ENVIRONMENT(val:uint):void
    {
      if (s_environmentSet)
      {
        return;
      }
      
      s_environment = val;
    }
    
    public static const ENVIRONMENT_EDITOR:uint = 1;
    public static const ENVIRONMENT_WEB:uint = 2;
  }

}