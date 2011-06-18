package com.errolzz.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class LoadingEvent extends Event 
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_PROGRESS:String = "loadProgress";
		public static const LOAD_QUEUE_COMPLETE:String = "loadQueueComplete";
		
		private var _vars:Object;
		
		/**
		 * 
		 * @param	type The event type;
		 * @param	item An item that has finished loading.
		 * @param	id The id of the loaded item.
		 */
		public function LoadingEvent(type:String, vars:Object = null) 
		{ 
			super(type);
			_vars = vars;
		} 
		
		public override function clone():Event 
		{ 
			return new LoadingEvent(type, _vars);
		} 
		
		public function get vars():Object { return _vars; }
		
		
	}
	
}