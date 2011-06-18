package com.errolzz.model 
{
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class ItemVO
	{
		public static const IMAGE:String = "image";
		public static const VIDEO:String = "video";
		public static const SWF:String = "swf";
		
		public var id:String;
		public var title:String;
		public var description:String;
		public var path:String;
		
		///The loaded content
		public var content:Object;
		
		///Either type ItemVO.IMAGE, ItemVO.VIDEO, or ItemVO.SWF
		private var _type:String;
		
		public function ItemVO(type:String) 
		{
			_type = type;
		}
		
		public function get type():String { return _type; }
		
	}

}