package com.errolzz.tools 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class Resizer 
	{
		
		public function Resizer() 
		{
			
		}
		
		/**
		 * Stretches the shortest side of the object to the longest size of the holder.
		 *	
		 * @param	thing A display object to be scaled
		 * @param	thingData An Object with properties w:Number for the original width and h:Number for original height
		 * @param	stage A stage Object
		 */
		public static function superScale(thing:DisplayObject, thingData:Object, stage:Stage):void
		{
			var thingSize:Number = thingData.w / thingData.h;
			var holderSize:Number = stage.stageWidth / stage.stageHeight;
			var scale:Number;
			
			if (thingSize <= holderSize) //if the thing is taller than the holder
			{
				scale = stage.stageWidth / thingData.w;
				thing.scaleX = thing.scaleY = scale;
				thing.x = 0;
				thing.y = (thingData.h * scale - stage.stageHeight) * -.5;
			}
			else //if the thing is wider than the holder
			{
				scale = stage.stageHeight / thingData.h;
				thing.scaleX = thing.scaleY = scale;
				thing.x = (thingData.w * scale - stage.stageWidth) * -.5;
				thing.y = 0;
			}
		}
		
		/**
		 * Stretches the object as big as it can while keeping proportion and not cropping.
		 * 
		 * @param	thing A display object to be scaled
		 * @param	thingData An Object with properties w:Number for the original width and h:Number for original height
		 * @param	stage A stage Object
		 */
		public static function letterBoxScale(thing:DisplayObject, thingData:Object, stage:Stage):void
		{
			var thingSize:Number = thingData.w / thingData.h;
			var holderSize:Number = stage.stageWidth / stage.stageHeight;
			var scale:Number;
			
			if (thingSize <= holderSize) //if the thing is taller than the holder
			{
				scale = stage.stageHeight / thingData.h;
				thing.scaleX = thing.scaleY = scale;
				thing.x = (stage.stageWidth * .5) - (thingData.w * scale * .5);
				thing.y = 0;
			}
			else //if the thing is wider than the holder
			{
				scale = stage.stageWidth / thingData.w;
				thing.scaleX = thing.scaleY = scale;
				thing.x = 0;
				thing.y = (stage.stageHeight * .5) - (thingData.h * scale * .5);
			}
		}
		
		/**
		 * Stretches the object as big as it can while keeping proportion and not cropping. Locked Y, not centered Y.
		 * 
		 * @param	thing A display object to be scaled
		 * @param	thingData An Object with properties w:Number for the original width and h:Number for original height
		 * @param	stage A stage Object
		 */
		public static function letterBoxLocked(thing:DisplayObject, thingData:Object, stage:Stage, yOffset:int = 0):void
		{
			var thingSize:Number = thingData.w / thingData.h;
			var holderSize:Number = stage.stageWidth / (stage.stageHeight - yOffset);
			var scale:Number;
			
			if (thingSize <= holderSize) //if the thing is taller than the holder
			{
				scale = (stage.stageHeight - yOffset) / thingData.h;
				thing.scaleX = thing.scaleY = scale;
				thing.x = int((stage.stageWidth * .5) - (thingData.w * scale * .5));
			}
			else //if the thing is wider than the holder
			{
				scale = stage.stageWidth / thingData.w;
				thing.scaleX = thing.scaleY = scale;
				thing.x = 0;
			}
			thing.y = 0;
		}
		
		public static function getLetterBoxData(thingData:Object, stage:Stage, yOffset:int = 0):Object
		{
			var thingSize:Number = thingData.w / thingData.h;
			var holderSize:Number = stage.stageWidth / (stage.stageHeight - yOffset);
			var scale:Number;
			var data:Object;
			
			if (thingSize <= holderSize) //if the thing is taller than the holder
			{
				scale = (stage.stageHeight - yOffset) / thingData.h;
				data.x = int((stage.stageWidth * .5) - (thingData.w * scale * .5));
				data.width = int(thingData.w * scale);
				data.height = thingData.h * scale;
			}
			else //if the thing is wider than the holder
			{
				scale = stage.stageWidth / thingData.w;
				data.x = 0;
				data.width = int(thingData.w * scale);
				data.height = thingData.h * scale;
			}
			
			return data;
		}
	}
	
}