package com.errolzz.abstract.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class AbstractScrollbar extends MovieClip
	{
		public var handle:MovieClip;
		public var track:MovieClip;
		
		private var _size:Number;
		private var _position:Number;
		private var _h:Boolean;
		
		public function AbstractScrollbar() 
		{
			
		}
		
		/**
		 * Call AFTER handle and track have been assigned.
		 */
		public function init(horizontal:Boolean = false):void
		{
			_h = horizontal;
			if (_h == false)
			{
				_size = track.height - handle.height;
			}
			else
			{
				_size = track.width;
			}
		}
		
		public function enable():void
		{
			handle.buttonMode = true;
			handle.addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
			handle.addEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
		}
		
		public function disable():void
		{
			handle.buttonMode = false;
			handle.removeEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
			handle.removeEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
			handle.removeEventListener(MouseEvent.MOUSE_OUT, onHandleOut);
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			}
		}
		
		protected function onHandleOver( event:MouseEvent ):void 
		{
			handle.removeEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
			handle.addEventListener(MouseEvent.MOUSE_OUT, onHandleOut);
		}
		
		protected function onHandleOut( event:MouseEvent ):void 
		{
			handle.removeEventListener(MouseEvent.MOUSE_OUT, onHandleOut);
			handle.addEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
		}
		
		protected function onHandleDown( event:MouseEvent ):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			handle.removeEventListener(MouseEvent.MOUSE_OUT, onHandleOut);
			handle.removeEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
			if (_h == false)
			{
				handle.startDrag(false, new Rectangle( 0, 0, 0, _size));
			}
			else
			{
				handle.startDrag(false, new Rectangle( 0, 0, _size, 0));
			}
		}
		
		protected function mouseUp( event:MouseEvent ):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			handle.addEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
			handle.stopDrag();
		}
		
		private function onDrag( event:MouseEvent ):void 
		{
			if (_h == false)
			{
				_position = handle.y / _size; 
			}
			else
			{
				_position = handle.x / _size; 
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function die():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			handle.removeEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
			handle.removeEventListener(MouseEvent.MOUSE_OUT, onHandleOut);
			handle.removeEventListener(MouseEvent.MOUSE_OVER, onHandleOver);
		}
		
		public function get position():Number { return _position; }
		
		public function set position(value:Number):void 
		{
			var v:Number;
			if (value >= 0 && value <= 1)
			{
				v = value
			}
			else if(value > 1)
			{
				v = 1;
			}
			else
			{
				v = 0;
			}
			
			if (_h == false)
			{
				handle.y = v * _size;
			}
			else
			{
				handle.x = v * _size;
			}
			onDrag(null);
		}
	}
	
}