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
    
    public static function load():void
    {
      var configJson:ByteArray = AssetManager.Get("assets/config.json") as ByteArray;
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
  }

}