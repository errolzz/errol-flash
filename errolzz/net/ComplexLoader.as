package com.errolzz.net 
{
	import com.errolzz.events.LoadingEvent;
	import com.errolzz.model.LoadingVO;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class ComplexLoader extends EventDispatcher
	{
		private var _paths:Array;
		private var _loader:Loader;
		private var _currentItem:int;
		private var _totalSize:Number;
		private var _totalProgress:Number;
		private var _sizeArray:Array;
		
		public function ComplexLoader() 
		{
			_totalSize = 0;
			_totalProgress = 0;
		}
		
		/**
		 * Loads items sequencially in a queue keeping track of total load size.
		 * Dispatches LoadingEvent.LOAD_PROGRESS with percent var and LoadingEvent.ITEM_COMPLETE
		 * with item var.
		 * @param	items array of item paths
		 */
		public function loadItems(items:Array):void
		{
			_sizeArray = new Array();
			_paths = items;
			_currentItem = 0;
			checkItemSize(_paths[_currentItem]);
		}
		
		/**
		 * Starts an item loading in order to get its total size.
		 * @param	path
		 */
		private function checkItemSize(path:String):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, sizeCheckStarted);
			_loader.load(new URLRequest(path));
		}
		
		/**
		 * Removes the progress listener and adds the items size to the _totalSize.
		 * If there are more items to check, checks the next items size.
		 * Otherwise, starts actual loading of items.
		 * @param	e
		 */
		private function sizeCheckStarted(e:ProgressEvent):void 
		{
			e.target.removeEventListener(ProgressEvent.PROGRESS, sizeCheckStarted);
			_totalSize += e.bytesTotal;
			_sizeArray[_currentItem] = e.bytesTotal;
			_loader.close();
			_loader = null;
			
			_currentItem++;
			if (_currentItem < _paths.length)
			{
				checkItemSize(_paths[_currentItem]);
			}
			else
			{
				_currentItem = 0;
				loadItem(_paths[_currentItem]);
			}
		}
		
		
		/**
		 * Loads and item, pretty normal.
		 * @param	path
		 */
		private function loadItem(path:String):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, itemComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandle);
			_loader.load(new URLRequest(path));
		}
		
		/**
		 * Tracks actual load progress of items.
		 * Adds bytesLoaded to totalProgress and calculates total percent done.
		 * @param	e
		 */
		private function loadProgressHandle(e:ProgressEvent):void 
		{
			var loaded:Number = _totalProgress + e.bytesLoaded;
			var perc:Number = loaded / _totalSize;
			
			dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_PROGRESS, new LoadingVO(null, null, loaded, _totalSize)));
		}
		
		/**
		 * Dispatches finished items.
		 * If there are more items to load, loads next item.
		 * Otherwise dispatches that the queue is finished.
		 * @param	e
		 */
		private function itemComplete(e:Event):void 
		{
			_totalProgress += _sizeArray[_currentItem];
			e.target.removeEventListener(Event.COMPLETE, itemComplete);
			e.target.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandle);
			dispatchEvent(new LoadingEvent(LoadingEvent.ASSET_COMPLETE, new LoadingVO(null, _loader.content)));
			
			_loader.unload();
			_loader = null;
			
			_currentItem++;
			if (_currentItem < _paths.length)
			{
				loadItem(_paths[_currentItem]);
			}
			else
			{
				_currentItem = 0;
				_totalProgress = 0;
				_sizeArray = [];
				dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_QUEUE_COMPLETE));
			}
		}
	}
	
}