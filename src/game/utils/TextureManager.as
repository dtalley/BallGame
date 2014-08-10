package src.game.utils 
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  import flash.geom.Rectangle;
  import flash.utils.ByteArray;
  import starling.textures.Texture;
  import flash.utils.Dictionary;
  import starling.textures.TextureAtlas;
	/**
   * ...
   * @author 
   */
  public class TextureManager 
  {
    private static var s_textures:Dictionary = new Dictionary();
    
    public static function CreateFromATF(name:String, image:ByteArray, scale:Number):Texture
    {
      var texture:Texture = Texture.fromAtfData(image, scale, false);
      s_textures[name] = texture;
      return texture;
    }
    
    public static function CreateFromBitmap(name:String, image:BitmapData, scale:Number):Texture
    {
      var texture:Texture = Texture.fromBitmapData(image, false, false, scale);
      s_textures[name] = texture;
      return texture;
    }
    
    public static function CreateAtlas(name:String, texture:Texture):TextureAtlas
    {
      var atlas:TextureAtlas = new TextureAtlas(texture);
      s_textures[name] = atlas;
      return atlas;
    }
    
    public static function ConfigureAtlas(atlasName:String, assetName:String):void
    {
      var texture:Texture = TextureManager.Get("assets/textures/" + ConfigManager.TEXTURE_SET + "/" + assetName + ".png");
      var atlas:TextureAtlas = TextureManager.CreateAtlas(atlasName, texture);
      
      var atlasJson:ByteArray = AssetManager.Get("assets/textures/" + ConfigManager.TEXTURE_SET + "/" + assetName + ".json") as ByteArray;
      var json:String = atlasJson.readUTFBytes(atlasJson.length);
      
      var obj:Array = JSON.parse(json) as Array;
      obj.forEach(function(spr:Array, a:*, b:*):void {
        atlas.addRegion(spr[0], new Rectangle(spr[1], spr[2], spr[3], spr[4]));
      });
    }
    
    public static function Get(name:String, subName:String = null):Texture
    {
      if ( !s_textures[name] )
      {
        return null;
      }
      
      if ( s_textures[name] is TextureAtlas && subName != null )
      {
        var atlas:TextureAtlas = s_textures[name] as TextureAtlas;
        return atlas.getTexture(subName);
      }
      else if ( s_textures[name] is Texture )
      {
        return s_textures[name];
      }
      
      return null;
    }
  }

}