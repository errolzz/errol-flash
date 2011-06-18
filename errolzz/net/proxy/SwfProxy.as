package com.errolzz.net.proxy
{
	import com.errolzz.model.LoadingVO;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import com.errolzz.events.LoadingEvent;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 * 
	 * Loads a swf and stores it.
	 * Also allows an id to be assigned.
	 * 
	 */
	public class SwfProxy extends EventDispatcher
	{
		private var _id:String;
		private var _loader:Loader;
		private var _swf:DisplayObject;
		private var _loaded:Boolean;
		private var _saveReference:Boolean;
		
		public function SwfProxy() 
		{
			_loaded = false;
			_loader = new Loader();
		}
		
		/**
		 * Loads a swf. Dispatches LoadingEvent.ASSET_COMPLETE when done.
		 * Dispatches LoadingEvent.LOAD_PROGRESS with vars {bytesLoaded:Number, bytesTotal:Number}.
		 * @param	swfPath
		 */
		public function loadSwf(swfPath:String, id:String = "", saveReference:Boolean = false):void 
		{
			_saveReference = saveReference;
			_id = id;
			
			if (_loaded == false)
			{
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandle);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfCompleteHandle);
				_loader.load(new URLRequest(swfPath), new LoaderContext(true));
			}
			else
			{
				throw new Error("This swf proxy already has a swf loaded.");
			}
		}
		
		private function progressHandle(e:ProgressEvent):void 
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_PROGRESS, new LoadingVO(_id, null, e.bytesLoaded, e.bytesTotal) ));
		}
		
		private function ioErrorHandle(e:IOErrorEvent):void 
		{
			removeListeners();
			//trace("IO Error handled, sir.");
			//trace(e.toString());
		}
		
		private function swfCompleteHandle(e:Event):void 
		{
			removeListeners();
			_swf = e.currentTarget.content;
			dispatchEvent(new LoadingEvent(LoadingEvent.ASSET_COMPLETE, new LoadingVO(_id, _swf)));
			
			if (_saveReference == false) die();
		}
		
		private function removeListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfCompleteHandle);
		}
		
		/**
		 * Removes all listeners, stops loading, and sets properties to null.
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
				if(_loader.content != null) _loader.unload();
			}
			if(_swf) _swf = null;
			if(_loader) _loader = null;
		}
		
		public function get swf():DisplayObject { return _swf; }
		
		public function get id():String { return _id; }
		
	}
	
}