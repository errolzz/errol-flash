package com.errolzz.tools
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class DrawTools 
	{
		
		public function DrawTools() 
		{
			
		}
		
		public static function drawRect(xPos:Number, yPos:Number, width:Number, height:Number, color:uint, opacity:Number = 1, borderWidth:int = 0, borderColor:uint = 0xff0000):Sprite
		{
			var bg:Sprite = new Sprite();
			
			if (borderWidth != 0)
			{
				bg.graphics.lineStyle(borderWidth, borderColor);
			}
			
			bg.graphics.beginFill(color);
			bg.graphics.drawRect(xPos, yPos, width, height);
			bg.graphics.endFill();
			bg.alpha = opacity;
			return(bg);
		}
	}
	
}