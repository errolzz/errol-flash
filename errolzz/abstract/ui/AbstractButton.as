package com.errolzz.abstract.ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class AbstractButton extends MovieClip
	{
		private var _data:Object;
		private var _clickHandle:Function;
		
		public function AbstractButton() 
		{
			mouseChildren = false;
		}
		
		public function enable():void
		{
			buttonMode = true;
			mouseEnabled = true;
			
			if (this.hasEventListener(MouseEvent.ROLL_OVER) == false)
			{
				addEventListener(MouseEvent.ROLL_OVER, rollOverHandle);
			}
		}
		
		public function disable(doRollOut:Boolean = false):void
		{
			buttonMode = false;
			mouseEnabled = false;
			if(doRollOut) rollOutHandle(null);
			die();
		}
		
		public function forceRollOver():void
		{
			rollOverHandle(null);
		}
		
		public function forceRollOut():void
		{
			rollOutHandle(null);
		}
		
		protected function onDataSet():void
		{
			
		}
		
		protected function rollOverHandle(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandle);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandle);
			if(_clickHandle != null) addEventListener(MouseEvent.CLICK, _clickHandle);
		}
		
		protected function rollOutHandle(e:MouseEvent):void 
		{
			if(_clickHandle != null) removeEventListener(MouseEvent.CLICK, _clickHandle);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandle);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandle);
		}
		
		public function die():void
		{
			if (_clickHandle != null) 
			{
				removeEventListener(MouseEvent.CLICK, _clickHandle);
			}
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandle);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandle);
		}
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
			onDataSet();
		}
		
		public function set clickHandle(value:Function):void 
		{
			_clickHandle = value;
		}
	}
	
}