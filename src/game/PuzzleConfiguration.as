package src.game 
{
  import flash.utils.ByteArray;
  import src.game.gadget.Combine;
  import src.game.gadget.Dispurse;
  import src.game.gadget.Expand;
  import src.game.gadget.GadgetManager;
  import src.game.gadget.Phase;
  import src.game.gadget.Rally;
  import src.game.gadget.Reverse;
	/**
   * ...
   * @author 
   */
  public class PuzzleConfiguration 
  {
    private var m_gadgets:Vector.<Boolean>;
    public function PuzzleConfiguration() 
    {
      m_gadgets = new Vector.<Boolean>();
      
      for ( var i:uint = 0; i < GadgetManager.s_gadgets.length; i++ )
      {
        m_gadgets.push(false);
      }
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
    }
    
    public function load(bytes:ByteArray):Boolean
    {
      if (bytes.bytesAvailable < 20)
      {
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
      
      m_gadgets[id] = false;
      if (test)
      {
        m_gadgets[id] = true;
      }
    }
  }

}