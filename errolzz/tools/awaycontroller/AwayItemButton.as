package com.errolzz.tools.awaycontroller 
{
	import away3d.core.base.Object3D;
	import com.errolzz.abstract.ui.AbstractButton;
	import com.errolzz.tools.DrawTools;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class AwayItemButton extends AbstractButton
	{
		private var _item:Object3D;
		
		public function AwayItemButton() 
		{
			super(this);
			this.mouseChildren = false;
		}
		
		public function setButton(item:Object3D):void
		{
			_item = item;
			
			addChild(DrawTools.drawRect(0, 0, 150, 20, 0x222222));
			
			var tf:TextField = new TextField();
			tf.width = 150;
			tf.height = 20;
			tf.text = item.name;
			tf.selectable = false;
			tf.textColor = 0x888888;
			addChild(tf);
			
			addChild(DrawTools.drawRect(0, 0, 150, 20, 0, 0));
		}
		
		public function get item():Object3D { return _item; }
	}
	
}