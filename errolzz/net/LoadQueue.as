package com.errolzz.net
{
	import com.errolzz.events.LoadingEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class LoadQueue extends EventDispatcher 
	{
		private var _queue:Array;
		private var _index:int;
		
		public function LoadQueue()
		{
			_queue = [];
			_index = 0;
		}
		
		/**
		 * Adds an image path to the queue.
		 * @param	path
		 */
		public function addItem(path:String, itemId:int):void
		{
			var loader:Loader = new Loader();
			_queue.push( { loader:loader, path:path, id:itemId } );
		}
		
		/**
		 * Loads items. Dispatches LoadingEvent.LOAD_COMPLETE with vars {content:e.target.content, id:_queue[_index].id.
		 * Dispatches LoadingEvent.LOAD_QUEUE_COMPLETE when finished.
		 */
		public function startQueue():void
		{
			if (_index == 0)
			{
				loadItem();
			}
			else
			{
				throw new Error("This queue's load index is not at 0.");
			}
		}
		
		private function loadItem():void
		{
			_queue[_index].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandle);
			_queue[_index].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandle);
			var path:String = (_queue[_index].path != null) ? _queue[_index].path : "";
			_queue[_index].loader.load(new URLRequest(path), new LoaderContext(true));
		}
		
		private function IOErrorHandle(e:IOErrorEvent):void 
		{
			e.target.removeEventListener(Event.COMPLETE, completeHandle);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandle);
			dispatchEvent(e.clone());
			//trace("Error handled, sir.");
			//trace("The problem was that, " + e);
			
			nextItem();
		}
		
		private function completeHandle(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, completeHandle);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandle);
			
			try{
				dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_COMPLETE, {content:e.target.content, id:_queue[_index].id}));
			}catch (err:Error) {
				//trace(err.getStack//trace());
				dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_COMPLETE, { loader:e.target.loader, id:_queue[_index].id } ));
			}
			nextItem();
		}
		
		private function nextItem():void
		{
			_index++;
			
			if (_index < _queue.length)
			{
				loadItem();
			}
			else
			{
				_index = 0;
				_queue = [];
				dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_QUEUE_COMPLETE));
				clearQueue();
			}
		}
		
		private function removeListeners():void
		{
			var len:int = _queue.length;
			for (var i:int = 0; i < len; i++)
			{
				_queue[i].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandle);
				_queue[i].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandle);
			}
		}
		
		/**
		 * Closes all open load streams, unloads all loaded content, resets queue index, and empties the queue.
		 */
		public function clearQueue():void
		{
			removeListeners();
			for (var i:uint = 0; i < _queue.length; i++)
			{
				try 
				{
					_queue[i].loader.close();
				}
				catch (e:Error)
				{
					if(_queue[i].loader.content != null) _queue[i].loader.unload();
				}
			}
			_index = 0;
			_queue = [];
		}
		
		public function get index():int { return _index; }
	}
}