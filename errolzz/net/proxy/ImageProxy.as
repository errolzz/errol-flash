package com.errolzz.net.proxy
{
	import com.errolzz.model.LoadingVO;
	import flash.display.Bitmap;
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
	 * Loads an image and stores the loaded Bitmap.
	 * Also allows an id to be assigned.
	 * 
	 */
	public class ImageProxy extends EventDispatcher
	{
		private var _loader:Loader;
		private var _image:Bitmap;
		private var _id:String;
		private var _loaded:Boolean;
		private var _saveReference:Boolean;
		
		public function ImageProxy() 
		{
			
		}
		
		/**
		 * Loads an image. Dispatches LoadingEvent.ASSET_COMPLETE when done.
		 * Dispatches LoadingEvent.LOAD_PROGRESS with vars {bytesLoaded:Number, bytesTotal:Number}.
		 * @param	imgPath
		 */
		public function loadImg(imgPath:String, id:String = "", saveReference:Boolean = false):void 
		{
			die();
			
			_loaded = false;
			_loader = new Loader();
			
			_saveReference = saveReference;
			_id = id;
			
			if (_loaded == false)
			{
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandle);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgCompleteHandle);
				_loader.load(new URLRequest(imgPath), new LoaderContext(true));
			}
			else
			{
				throw new Error("This img proxy already has an img loaded.");
			}
		}
		
		private function progressHandle(e:ProgressEvent):void 
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_COMPLETE, { loaded:e.bytesLoaded, total:e.bytesTotal } ));
		}
		
		private function ioErrorHandle(e:IOErrorEvent):void 
		{
			removeListeners();
			//trace("IO Error handled, sir.");
			//trace(e.toString());
		}
		
		private function imgCompleteHandle(e:Event):void 
		{
			removeListeners();
			_image = new Bitmap(e.target.content.bitmapData);
			dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_COMPLETE, { id:_id, image:_image } ));
			
			if (_saveReference == false) die();
		}
		
		private function removeListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandle);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgCompleteHandle);
		}
		
		/**
		 * Removes all listeners, stops loading, and sets all properties to null.
		 */
		public function die():void
		{
			removeListeners();
			try
			{
				_loader.close();
			}
			catch(e:Error)
			{
				if(_loader.content != null) _loader.unload();
			}
			if(_image) _image = null;
			if(_loader) _loader = null;
		}
		
		public function get image():Bitmap { return _image; }
		
		public function get id():String { return _id; }
		
	}
	
}