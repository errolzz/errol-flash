package com.errolzz.events 
{
	import com.errolzz.events.AbstractEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 * 
	 */
	public class ClipEvent extends Event
	{
		public static var CLIP_SELECT:String = "clipSelect";
		public static var CLIP_READY:String = "clipReady";
		public static var CLIP_INFO_SEND:String = "clipInfoSend";
		public static var ANIMATE_IN_COMPLETE:String = "animateInComplete";
		public static var ANIMATE_OUT_COMPLETE:String = "animateOutComplete";
		
		private var _vars:Object;
		
		public function ClipEvent(type:String, vars:Object = null, bubbles:Boolean = true) 
		{
			super(type, bubbles);
			_vars = _vars;
		}
		
		public override function clone():Event 
		{ 
			return new ClipEvent(type, _vars, bubbles);
		} 
		
		public function get vars():Object { return _vars; }
		
	}
	
}