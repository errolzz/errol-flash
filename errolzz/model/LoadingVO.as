package com.errolzz.model 
{
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class LoadingVO
	{
		private var _id:String;
		private var _item:Object;
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		
		public function LoadingVO(id:String = null, item:Object = null, bytesLoaded:uint = 0, bytesTotal:uint = 0) 
		{
			_id = id;
			_item = item;
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
		}
		
		public function get id():String { return _id; }
		
		public function get item():Object { return _item; }
		
		public function get bytesLoaded():uint { return _bytesLoaded; }
		
		public function get bytesTotal():uint { return _bytesTotal; }
		
	}

}