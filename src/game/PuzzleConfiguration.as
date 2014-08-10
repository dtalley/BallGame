package src.game 
{
  import flash.utils.ByteArray;
  import src.game.gadget.Combine;
  import src.game.gadget.Dispurse;
  import src.game.gadget.Expand;
  import src.game.gadget.GadgetManager;
  import src.game.gadget.Phase;
  import src.game.gadget.Rally;
  import src.game.gadget.Redirect;
  import src.game.gadget.Reverse;
	/**
   * ...
   * @author 
   */
  public class PuzzleConfiguration 
  {
    private var m_puzzle:PuzzleList;
    private var m_gadgets:Vector.<Boolean>;
    
    public function PuzzleConfiguration() 
    {
      m_gadgets = new Vector.<Boolean>();
      
      for ( var i:uint = 0; i < GadgetManager.s_gadgets.length; i++ )
      {
        m_gadgets.push(false);
      }
    }
    
    public function set puzzle(val:PuzzleList):void
    {
      m_puzzle = val;
    }
    
    public function get puzzle():PuzzleList
    {
      return m_puzzle;
    }
    
    public function copy(other:PuzzleConfiguration):void
    {
      if (!other)
      {
        return;
      }
      
      for ( var i:uint = 0; i < GadgetManager.s_gadgets.length; i++ )
      {
        m_gadgets[i] = other.m_gadgets[i];
      }
      
      m_puzzle = other.puzzle;
    }
    
    public function save(bytes:ByteArray):Boolean
    {
      //Header
      bytes.writeMultiByte("bpfh", "us-ascii");
      
      //Version (1.0)
      bytes.writeByte(1);
      bytes.writeByte(0);
      
      var d1:uint = 0;
      var d2:uint = 0;
      
      for ( var i:uint = 0; i < m_gadgets.length; i++ )
      {
        var value:uint = m_gadgets[i] ? 1 : 0;
        if ( i >= 32 )
        {
          d2 |= ( value << ( i - 32 ) );
        }
        else
        {
          d1 |= ( value << i );
        }
      }
      
      bytes.writeUnsignedInt(d1);
      bytes.writeUnsignedInt(d2);
      
      return true;
    }
    
    public function load(bytes:ByteArray):Boolean
    {
      if (bytes.bytesAvailable < 20)
      {
        trace("Not enough bytes available in ByteArray");
        return false;
      }
      
      var header:String = bytes.readMultiByte(4, "us-ascii");
      if (header != "bpfh")
      {
        trace("Invalid puzzle file, header was '" + header + "'");
        return false;
      }
      
      var jv:uint = bytes.readByte(); //Major version
      var nv:uint = bytes.readByte(); //Minor version
      
      var d1:uint = bytes.readUnsignedInt();
      var d2:uint = bytes.readUnsignedInt();
      
      loadGadgetStatus(Reverse, d1, d2);
      loadGadgetStatus(Rally, d1, d2);
      loadGadgetStatus(Dispurse, d1, d2);
      loadGadgetStatus(Phase, d1, d2);
      loadGadgetStatus(Combine, d1, d2);
      loadGadgetStatus(Expand, d1, d2);
      loadGadgetStatus(Redirect, d1, d2);
      
      return true;
    }
    
    private function loadGadgetStatus(type:Class, d1:uint, d2:uint):void
    {
      var id:uint = GadgetManager.s_gadgets.indexOf(type);
      var test:uint = 0;
      if (id > 32)
      {
        test = d2 & ( 1 << ( id - 32 ) );
      }
      else
      {
        test = d1 & ( 1 << id );
      }
      
      m_gadgets[id] = test > 0;
    }
    
    public function enable(type:Class):void
    {
      var idx:int = GadgetManager.s_gadgets.indexOf(type);
      if (idx >= 0)
      {
        m_gadgets[idx] = true;
      }
    }
    
    public function disable(type:Class):void
    {
      var idx:int = GadgetManager.s_gadgets.indexOf(type);
      if (idx >= 0)
      {
        m_gadgets[idx] = false;
      }
    }
    
    public function isEnabled(type:Class):Boolean
    {
      var idx:int = GadgetManager.s_gadgets.indexOf(type);
      if (idx >= 0)
      {
        return m_gadgets[idx];
      }
      return false;
    }
    
    public function configureFromButtonTree(tree:ButtonTree, type:Class):void
    {
      var idx:int = GadgetManager.s_gadgets.indexOf(type);
      if (idx < 0)
      {
        return;
      }
      m_gadgets[idx] = tree.isToggled;
    }
    
    public function configureButtonTree(tree:ButtonTree, type:Class):void
    {
      tree.clearToggle();
      if (isEnabled(type))
      {
        tree.setToggle();
      }
    }
  }

}