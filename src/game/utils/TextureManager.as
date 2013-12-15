package src.game.utils 
{
  import flash.display.Bitmap;
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
    
    public static function Create(name:String, image:Bitmap):Texture
    {
      var texture:Texture = Texture.fromBitmap(image, false);
      s_textures[name] = texture;
      return texture;
    }
    
    public static function CreateAtlas(name:String, texture:Texture):TextureAtlas
    {
      var atlas:TextureAtlas = new TextureAtlas(texture);
      s_textures[name] = atlas;
      return atlas;
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