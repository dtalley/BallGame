package src.game.utils 
{
  import flash.utils.ByteArray;
	/**
   * ...
   * @author 
   */
  public class ConfigManager 
  {
    private static var s_tileSize:uint;
    private static var s_padding:uint;
    private static var s_environment:uint;
    
    public static function load():void
    {
      var configJson:ByteArray = null;
      configJson = AssetManager.Get("assets/config_editor.json") as ByteArray;
      
      if (!configJson)
      {
        configJson = AssetManager.Get("assets/config_web.json") as ByteArray;  
      }
      
      if (!configJson)
      {
        throw new Error("Could not load configuration file.");
      }
      
      var json:String = configJson.readUTFBytes(configJson.length);
      
      var obj:Object = JSON.parse(json) as Object;
      
      s_tileSize = parseInt(obj.tileSize);
      s_padding = parseInt(obj.padding);
      s_environment = parseInt(obj.environment);
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
    
    public static const ENVIRONMENT_EDITOR:uint = 1;
    public static const ENVIRONMENT_WEB:uint = 2;
  }

}