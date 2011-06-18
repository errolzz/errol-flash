package com.errolzz.abstract 
{
	import com.errolzz.events.ClipEvent;
	import com.errolzz.events.LoadingEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 * 
	 * Standard module base class.
	 * 
	 */
	public class AbstractClip extends MovieClip
	{
		
		public function AbstractClip(self:AbstractClip) 
		{
			disable();
			addEventListener(Event.ADDED_TO_STAGE, stageReady);
		}
		
		/**
		 * Sets the position and some other stuff of the clip.
		 * @param	xPos
		 * @param	yPos
		 * @param	opacity
		 * @param	xScale
		 * @param	yScale
		 */
		public function setup(xPos:Number, yPos:Number, opacity:Number = 1, xScale:Number = 1, yScale:Number = 1):void
		{
			this.x = xPos;
			this.y = yPos;
			this.alpha = opacity;
			this.scaleX = xScale;
			this.scaleY = yScale;
		}
		
		/**
		 * Blank function.
		 */
		public function animateIn():void
		{
			
		}
		
		/**
		 * Blank function, use with animateOutComplete().
		 */
		public function animateOut():void
		{
			
		}
		
		/**
		 * Disables mouse actions. No listeners are removed.
		 */
		public function disable():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		/**
		 * Kills all clips.
		 */
		public function die():void
		{
			killAllClips();
		}
		
		/**
		 * Enables mouse actions. No listeners are added.
		 */
		public function enable():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		/**
		 * Stops and removes all children from the stage.
		 */
		public function killAllClips():void
		{
			while (this.numChildren > 0)
			{
				try {
					MovieClip(getChildAt(0)).stop();
				}catch (e:Error) {
					
				}
				removeChildAt(0);
			}
		}
		
		/**
		 * Dispatches ClipEvent.ANIMATE_OUT_COMPLETE which should be listened for in the minons parent.
		 */
		protected function animateOutComplete():void
		{
			dispatchEvent(new ClipEvent(ClipEvent.ANIMATE_OUT_COMPLETE));
		}
		
		protected function stageReady(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
	}
	
}