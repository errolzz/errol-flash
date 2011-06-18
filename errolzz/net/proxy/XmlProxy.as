package com.errolzz.net.proxy 
{
	import com.errolzz.model.LoadingVO;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.errolzz.events.LoadingEvent;
	import flash.events.Event;
	import com.errolzz.events.LoadingEvent;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 * 
	 * Loads xml and stores it for later use.
	 * 
	 */
	public class XmlProxy extends EventDispatcher
	{
		private var _loader:URLLoader;
		private var _xml:XML;
		private var _loaded:Boolean;
		
		public function XmlProxy() 
		{
			
		}
		
		/**
		 * Loads an xml file. Dispatches Event.COMPLETE when done.
		 * 
		 * @param	xmlPath
		 */
		public function loadXml(xmlPath:String):void 
		{
			_loaded = false;
			_loader = new URLLoader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.addEventListener(Event.COMPLETE, xmlCompleteHandle);
			_loader.load(new URLRequest(xmlPath));
		}
		
		private function ioErrorHandle(e:IOErrorEvent):void 
		{
			removeListeners();
			//trace("XmlProxy - Line 57: IO Error handled, sir.");
			//trace(e.toString);
			die();
		}
		
		private function xmlCompleteHandle(e:Event):void 
		{
			removeListeners();
			_xml = new XML(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function removeListeners():void
		{
			if (_loader)
			{
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
				_loader.removeEventListener(Event.COMPLETE, xmlCompleteHandle);
			}
		}
		
		/**
		 * Removes all listeners, stops loading, and sets properties to null.
		 * Called automatically if saveReference == false.
		 */
		public function die():void
		{
			removeListeners();
			try
			{
				_loader.close();
			}
			catch(e)
			{
				
			}
			if(_xml) _xml = null;
			if(_loader) _loader = null;
		}
		
		public function get xml():XML { return _xml; }
	}
	
}