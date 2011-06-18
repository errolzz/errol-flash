package com.errolzz.tools
{
	
	/**
	* ...
	* @author Errol Schwartz
	*/
	public class TimeConverter  
	{
		public function TimeConverter()
		{
			
		}
		
		public static function decimalToClock(time:Number):String
		{
			var t:Number = Math.round(time);
			var min:Number = Math.floor(t/60);
			var sec:Number = t%60;
			var clockTime:String = new String("");
			
			if (min < 10) clockTime += "0";
			
			if (min >= 1) 
			{
				clockTime += min.toString();
			}
			else
			{
				clockTime += "0";
			}
			
			clockTime += ":";
			
			if (sec < 10) 
			{
				clockTime += "0";
				clockTime += sec.toString();
			} 
			else 
			{
				clockTime += sec.toString();
			}
			
			return(clockTime);
		}
	}
	
}