package com.errolzz.tools 
{
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class TextTools
	{
		
		public function TextTools() 
		{
			
		}
		
		public static function toTitleCase(text:String):String
		{
			var a:Array;
			var t:String = "";
			
			a = text.split(" ");
			var words:int = a.length;
			
			for (var i:int = 0; i < words; i++) 
			{
				a[i] = String(a[i]).toLowerCase();
				a[i] = String(a[i]).substring(0, 1).toUpperCase() + String(a[i]).substring(1);
				t += a[i];
				if (i < words - 1) t += " ";
			}
			
			return t;
		}
		
		public static function removeHtml(text:String):String
		{
			var re:RegExp = new RegExp(/<.*?>/g);
			text.replace(re, "");
			return text;
		}
	}

}