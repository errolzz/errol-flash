package com.errolzz.tools.awaycontroller 
{
	import away3d.core.base.Object3D;
	import com.errolzz.abstract.ui.AbstractButton;
	import com.errolzz.tools.DrawTools;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class AwaySliderControl extends AbstractButton
	{
		private var _tf:TextField;
		private var _item:Object3D;
		private var _action:String;
		private var _controlPoint:Number;
		private var _origX:Number;
		private var _origY:Number;
		private var _origZ:Number;
		private var _origRx:Number;
		private var _origRy:Number;
		private var _origRz:Number;
		
		public function AwaySliderControl(label:String) 
		{
			super(this);
			
			_controlPoint = -666666;
			_action = label;
			
			var l:TextField = new TextField();
			l.width = 25;
			l.height = 20;
			l.text = label + ":";
			l.selectable = false;
			l.textColor = 0x888888;
			addChild(l);
			
			_tf = new TextField();
			_tf.width = 75;
			_tf.height = 20;
			_tf.x = 25;
			_tf.textColor = 0x555555;
			_tf.selectable = false;
			_tf.text = "??????";
			addChild(_tf);
			
			addChild(DrawTools.drawRect(0, 0, 100, 20, 0x151515, 0));
			
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
		}
		
		private function mouseDownHandle(e:MouseEvent):void 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandle);
			
			if (_controlPoint == -666666)
			{
				_controlPoint = stage.mouseX;
				_origX = _item.x;
				_origY = _item.y;
				_origZ = _item.z;
				_origRx = _item.rotationX;
				_origRy = _item.rotationY;
				_origRz = _item.rotationZ;
			}
		}
		
		private function mouseMoveHandle(e:MouseEvent):void 
		{
			moveItem();
		}
		
		private function mouseUpHandle(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandle);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			_controlPoint = -666666;
		}
		
		private function moveItem():void
		{
			var dif:Number = stage.mouseX - _controlPoint;
			switch(_action)
			{
				case "px":
					_item.x = _origX + dif;
					break;
				case "py":
					_item.y = _origY + dif;
					break;
				case "pz":
					_item.z = _origZ + dif;
					break;
				case "rx":
					_item.rotationX = _origRx + dif;
					break;
				case "ry":
					_item.rotationY = _origRy + dif;
					break;
				case "rz":
					_item.rotationZ = _origRz + dif;
					break;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get tf():TextField { return _tf; }
		
		public function set item(value:Object3D):void 
		{
			_item = value;
		}
		
	}
	
}