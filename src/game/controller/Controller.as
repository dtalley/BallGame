package src.game.controller 
{
  import flash.events.IEventDispatcher;
  
  /**
   * ...
   * @author 
   */
  public interface Controller extends IEventDispatcher
  {
    function Update(elapsed:Number):void;
    function Activate(previous:Controller):void;
    function Deactivate():void;
  }
  
}