package src.game.utils 
{
  import flash.events.Event;
  import flash.utils.Dictionary;
	/**
   * ...
   * @author 
   */
  public class AssetManager
  {
    private static var s_assets:Dictionary;
    
    public static function Initialize():void
    {
      s_assets = new Dictionary();
    }
    
    public static function Load(path:String, progress:Function, complete:Function):void
    {
      var loader:AssetLoader = new AssetLoader(path, progress, complete);
      loader.addEventListener(Event.COMPLETE, assetLoaded);
      loader.addEventListener("error", assetError);
    }
    
    public static function LoadBundle(paths:Array, progress:Function, complete:Function):void
    {
      var bundle:AssetBundle = new AssetBundle(paths, progress, complete);
      bundle.addEventListener(Event.COMPLETE, assetLoaded);
      bundle.addEventListener("error", assetError);
    }
    
    private static function assetLoaded(e:Event):void
    {
      var loader:AssetLoader = e.target as AssetLoader;
      s_assets[loader.path] = loader;
    }
    
    private static function assetError(e:Event):void
    {
      var loader:AssetLoader = e.target as AssetLoader;
    }
    
    public static function Get(path:String):*
    {
      if ( s_assets[path] )
      {
        var asset:AssetLoader = s_assets[path] as AssetLoader;
        return asset.loader;
      }
      
      return null;
    }
  }
}
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;

class AssetBundle extends EventDispatcher
{
  private var m_progress:Function;
  private var m_complete:Function;
  
  private var m_total:uint = 0;
  private var m_loaded:uint = 0;
  
  private var m_loaders:Vector.<AssetLoader> = new Vector.<AssetLoader>();
  
  public function AssetBundle(paths:Array, progress:Function = null, complete:Function = null):void
  {
    m_progress = progress;
    m_complete = complete;
    
    paths.forEach(function(path:String):void {
      this.m_total++;
      this.m_loaders.push(new AssetLoader(path, this.LoaderProgress, this.LoaderComplete));
    }, this);
  }
  
  public function LoaderProgress(percent:Number):void
  {
    
  }
  
  public function LoaderComplete(e:Error):void
  {
    if ( e )
    {
      m_complete(e);
      return;
    }
    
    m_loaded++;
    
    if ( m_loaded == m_total )
    {
      m_complete(null);
    }
  }
}

class AssetLoader extends EventDispatcher
{
  private var m_path:String;
  private var m_progress:Function;
  private var m_complete:Function;
  
  private var m_loader:Loader;
  
  public function AssetLoader(path:String, progress:Function = null, complete:Function = null):void
  {
    m_path = path;
    m_progress = progress;
    m_complete = complete;
    
    m_loader = new Loader();
    m_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.loadProgress);
    m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadComplete);
    m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
    m_loader.load(new URLRequest(path));
  }
  
  private function loadProgress(e:ProgressEvent):void
  {
    var percent:Number = e.bytesLoaded / e.bytesTotal;
    if ( m_progress != null )
    {
      m_progress(percent);
    }
  }
  
  private function loadError(e:IOErrorEvent):void
  {
    if ( m_complete != null )
    {
      m_complete(new Error(e.text, e.errorID));
    }
  }
  
  private function loadComplete(e:Event):void
  {
    this.dispatchEvent(new Event(Event.COMPLETE, true));
    if ( m_complete != null )
    {
      m_complete(null);
    }
  }
  
  public function get path():String
  {
    return m_path;
  }
  
  public function get loader():Loader
  {
    return m_loader;
  }
}