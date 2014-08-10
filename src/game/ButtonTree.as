package src.game 
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import starling.events.TouchEvent;
	/**
   * ...
   * @author 
   */
  public class ButtonTree extends EventDispatcher
  {
    public static const BLANK:uint = 0;
    public static const NORMAL:uint = 1;
    public static const SELECTABLE:uint = 2;
    public static const TOGGLE:uint = 4;
    public static const PUSH:uint = 8;
    public static const POP:uint = 16;
    
    private var m_panel:Panel;
    private var m_parent:ButtonTree;
    private var m_name:String;
    private var m_mode:uint;
    
    private var m_button:PanelButton;
    
    private var m_icons:Vector.<String> = new Vector.<String>();
    private var m_children:Vector.<ButtonTree> = new Vector.<ButtonTree>();
    
    private var m_count:uint = 0;
    
    private var m_selected:ButtonTree = null;
    private var m_defaultSelection:ButtonTree = null;
    
    private var m_toggleHeld:Boolean = false;
    private var m_timer:Timer = null;
    private var m_toggled:Boolean = false;
    
    public function ButtonTree(name:String, mode:uint, parent:ButtonTree = null):void
    {
      m_name = name;
      m_mode = mode;
      m_parent = parent;
    }
    
    public function clearChildren():void
    {
      while (m_children.length)
      {
        removeChild(m_children[0]);
      }
    }
    
    public function removeChild(child:ButtonTree):void
    {
      var idx:int = m_children.indexOf(child);
      if (idx < 0)
      {
        return;
      }
      
      m_children.splice(idx, 1);
      m_count--;
      if (child.mode & ButtonTree.SELECTABLE)
      {
        child.removeEventListener("selected", this.childSelected);
        
        if (m_defaultSelection == child)
        {
          m_defaultSelection = null;
        }
      }
      else if ( child.mode == ButtonTree.PUSH )
      {
        child.removeEventListener("push", this.pushTree);
      }
      else if ( child.mode == ButtonTree.POP )
      {
        child.removeEventListener("pop", this.popTree);
      }
    }
    
    public function addChild(child:ButtonTree, selected:Boolean = false ):void
    {
      var idx:int = m_children.indexOf(child);
      if (idx >= 0)
      {
        return;
      }
      
      m_children.push(child);
      m_count++;
      
      if ( child.mode & ButtonTree.SELECTABLE )
      {
        child.addEventListener("selected", this.childSelected);
        
        if ( selected )
        {
          m_defaultSelection = child;
        }
      }
      else if ( child.mode == ButtonTree.PUSH )
      {
        child.addEventListener("push", this.pushTree);
      }
      else if ( child.mode == ButtonTree.POP )
      {
        child.addEventListener("pop", this.popTree);
      }
    }
    
    public function createChild(name:String, mode:uint = NORMAL, selected:Boolean = false):ButtonTree
    {
      var child:ButtonTree = new ButtonTree(name, mode, this);
      
      addChild(child, selected);
      
      return child;
    }
    
    public function set panel(val:Panel):void
    {
      m_panel = val;
    }
    
    private function pushTree(e:Event):void
    {
      m_panel.loadTree(e.target as ButtonTree);
    }
    
    private function popTree(e:Event):void
    {
      m_panel.loadTree(m_parent);
    }
    
    private function childSelected(e:Event):void
    {
      if ( m_selected )
      {
        m_selected.deselect();
      }
      
      m_selected = e.target as ButtonTree;
    }
    
    public function unload():void
    {
      this.deselect();
      
      if ( m_button )
      {
        m_button.removeEventListener(TouchEvent.TOUCH, buttonTouched);
        m_button.removeIcon();
      }
      m_button = null;
      
      for ( var i:int = 0; i < m_count; i++ )
      {
        m_children[i].unload();
      }
    }
    
    public function activate():void
    {
      if ( m_defaultSelection )
      {
        m_selected = m_defaultSelection;
        m_selected.select();
      }
      else
      {
        m_selected = null;
      }
    }
    
    public function load(button:PanelButton):void
    {
      m_button = button;
      m_button.clearToggle();
      
      if (m_toggled)
      {
        m_button.setToggle();
      }
      
      if ( m_mode == ButtonTree.BLANK )
      {
        m_button.removeIcon();
      }
      else
      {
        m_button.setIcon(m_name);
        m_button.addEventListener(TouchEvent.TOUCH, buttonTouched);
      }
    }
    
    private function buttonTouched(e:TouchEvent):void
    {
      if ( e.touches[0].phase != "began" || !m_button )
      {
        if (e.touches[0].phase == "ended" && m_toggleHeld)
        {
          m_toggleHeld = false;
          m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.toggleTimerComplete);
          m_timer = null;
        }
        return;
      }
      
      m_toggleHeld = false;
      
      if ( m_mode & ButtonTree.PUSH )
      {
        //m_button.activate();
        
        dispatchEvent(new Event("push"));
      }
      else if ( m_mode & ButtonTree.POP )
      {
        //m_button.activate();
        
        dispatchEvent(new Event("pop"));
      }
      else if ( m_mode & ButtonTree.NORMAL )
      {
        m_button.activate();
        
        dispatchEvent(new Event("activated"));
      }
      else if ( m_mode & ButtonTree.SELECTABLE )
      {
        if ( !m_button.isSelected )
        {
          m_button.select();
          dispatchEvent(new Event("selected"));
        }
      }
      
      if ( m_mode & ButtonTree.TOGGLE )
      {
        m_toggleHeld = true;
        m_timer = new Timer(750, 1);
        m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.toggleTimerComplete);
        m_timer.start();
      }
    }
    
    private function toggleTimerComplete(e:Event):void
    {
      m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.toggleTimerComplete);
      m_timer = null;
      m_toggleHeld = false;
      
      m_toggled = !m_toggled;
      if (m_toggled)
      {
        m_button.setToggle();
      }
      else
      {
        m_button.clearToggle();
      }
    }
    
    public function setToggle():void
    {
      if (!m_toggled)
      {
        m_toggled = true;
        if (m_button)
        {
          m_button.setToggle();
        }
      }
    }
    
    public function clearToggle():void
    {
      if (m_toggled)
      {
        m_toggled = false;
        if (m_button)
        {
          m_button.clearToggle();
        }
      }
    }
    
    public function get isToggled():Boolean
    {
      return m_toggled;
    }
    
    public function select():void
    {
      if ( m_mode == ButtonTree.SELECTABLE && !m_button.isSelected )
      {
        m_button.select();
      }
    }
    
    public function deselect():void
    {
      if ( ( m_mode & ButtonTree.SELECTABLE ) != 0 && m_button && m_button.isSelected )
      {
        m_button.deselect();
      }
    }
    
    public function getChild(index:uint):ButtonTree
    {
      if ( m_children.length > index )
      {
        return m_children[index];
      }
      
      throw new Error("Out of bounds access in ButtonTree: " + index + " of " + m_count);
    }
    
    public function get name():String
    {
      return m_name;
    }
    
    public function get mode():uint
    {
      return m_mode;
    }
    
    public function get isRoot():Boolean
    {
      return m_parent === null;
    }
    
    public function get parent():ButtonTree
    {
      return m_parent;
    }
    
    public function get count():uint
    {
      return m_count;
    }
    
    public function get isSelected():Boolean
    {
      if ( !m_button )
      {
        return false;
      }
      
      if ( ( m_mode & ButtonTree.SELECTABLE ) != 0 && m_button.isSelected )
      {
        return true;
      }
      
      return false;
    }
  }

}