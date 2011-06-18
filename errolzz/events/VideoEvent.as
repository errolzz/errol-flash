package com.errolzz.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 * 
	 */
	public class VideoEvent extends Event
	{
		public static var START_SEEK:String = "startSeek";
		public static var STOP_SEEK:String = "stopSeek";
		public static var META_DATA_READY:String = "metaDataReady";
		public static var TO_FULLSCREEN:String = "toFullscreen";
		public static var FROM_FULLSCREEN:String = "fromFullscreen";
		
		private var _vars:Object;
		
		public function VideoEvent(type:String, vars:Object = null, bubbles:Boolean = true) 
		{
			super(type, bubbles);
			_vars = _vars;
		}
		
		public override function clone():Event 
		{ 
			return new VideoEvent(type, _vars, bubbles);
		} 
		
		public function get vars():Object { return _vars; }
		
	}
	
}