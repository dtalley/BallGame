package src.game.utils 
{
	/**
   * ...
   * @author 
   */
  public class MathX
  {
    public static function within(val:Number, min:Number, max:Number, exclusive:Boolean = false):Boolean
    {
      if ( exclusive )
      {
        return val > min && val < max;
      }
      return val >= min && val <= max;
    }
    
    public static function clamp(val:Number, min:Number, max:Number):Number
    {
      if ( val < min )
      {
        return min;
      }
      
      if ( val > max )
      {
        return max;
      }
      
      return val;
    }
  }

}