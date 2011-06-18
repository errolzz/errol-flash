package com.errolzz.tools 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class MemoryGauge extends Sprite
	{
		
		public function MemoryGauge() 
		{
			this.mouseEnabled = this.mouseChildren = false;
			
			this.graphics.beginFill(0);
			this.graphics.drawRect(0, 0, 66, 30);
			this.graphics.endFill();
			
			var tf:TextField = new TextField();
			tf.textColor = 0xffffff;
			tf.width = 54;
			tf.x = 6;
			tf.y = 6;
			addChild(tf);
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			var tf:TextField = this.getChildAt(0) as TextField;
			tf.text = Number(System.totalMemory / 1048576).toFixed(3);
		}
		
	}

}