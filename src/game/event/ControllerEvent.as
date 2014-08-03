package src.game.event 
{
  import flash.events.Event;
  import src.game.controller.ControllerConfiguration;
  
  /**
   * ...
   * @author 
   */
  public class ControllerEvent extends Event 
  {
    private var m_name:String;
    private var m_configuration:ControllerConfiguration;
    
    public function ControllerEvent(type:String, name:String, configuration:ControllerConfiguration = null, bubbles:Boolean=false, cancelable:Boolean=false) 
    { 
      super(type, bubbles, cancelable);
      
      m_name = name;
      m_configuration = configuration;
      if (!m_configuration)
      {
        m_configuration = new ControllerConfiguration();
      }
    } 
    
    public override function clone():Event 
    { 
      return new ControllerEvent(type, m_name, m_configuration, bubbles, cancelable);
    } 
    
    public override function toString():String 
    { 
      return formatToString("ControllerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
    }
    
    public function get name():String
    {
      return m_name;
    }
    
    public function get configuration():ControllerConfiguration
    {
      return m_configuration;
    }
    
    public static const CHANGE_CONTROLLER:String = "orn_changeController";
  }  
}