package com.errolzz.tools.awaycontroller 
{
	import away3d.core.base.Object3D;
	import com.errolzz.abstract.ui.AbstractButton;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.errolzz.tools.DrawTools;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class AwayController extends MovieClip
	{
		private var _items:Array;
		private var _currentItem:Object3D;
		private var _title_txt:TextField;
		
		private var _px:AwaySliderControl;
		private var _py:AwaySliderControl;
		private var _pz:AwaySliderControl;
		private var _rx:AwaySliderControl;
		private var _ry:AwaySliderControl;
		private var _rz:AwaySliderControl;
		private var _copy:TextField;
		
		public function AwayController(items:Array) 
		{
			_items = new Array();
			createBox();
			createControls();
			createButtons(items);
			
			setCurrentItem(items[0]);
			changeHandle(null);
		}
		
		private function createBox():void
		{
			var bg:Sprite = DrawTools.drawRect(0, 0, 200, 100, 0x222222);
			addChild(bg);
			
			var pc:Sprite = DrawTools.drawRect(0, 25, 100, 75, 0x111111);
			addChild(pc);
			
			var rc:Sprite = DrawTools.drawRect(100, 25, 100, 75, 0x151515);
			addChild(rc);
			
			_title_txt = new TextField();
			_title_txt.width = 170;
			_title_txt.height = 25;
			_title_txt.x = 3;
			_title_txt.y = 2;
			_title_txt.text = "SEFsffse";
			_title_txt.textColor = 0xdddddd;
			_title_txt.selectable = false;
			addChild(_title_txt);
		}
		
		private function createControls():void
		{
			var m:Sprite = DrawTools.drawRect(175, 8, 20, 10, 0x111111);
			m.addEventListener(MouseEvent.CLICK, menuClickHandle);
			m.buttonMode = true;
			addChild(m);
			
			//==
			
			_px = new AwaySliderControl("px");
			_px.addEventListener(Event.CHANGE, changeHandle);
			_px.x = 3;
			_px.y = 25;
			addChild(_px);
			
			_py = new AwaySliderControl("py");
			_py.addEventListener(Event.CHANGE, changeHandle);
			_py.x = 3;
			_py.y = 50;
			addChild(_py);
			
			_pz = new AwaySliderControl("pz");
			_pz.addEventListener(Event.CHANGE, changeHandle);
			_pz.x = 3;
			_pz.y = 75;
			addChild(_pz);
			
			//==
			
			_rx = new AwaySliderControl("rx");
			_rx.addEventListener(Event.CHANGE, changeHandle);
			_rx.x = 103;
			_rx.y = 25;
			addChild(_rx);
			
			_ry = new AwaySliderControl("ry");
			_ry.addEventListener(Event.CHANGE, changeHandle);
			_ry.x = 103;
			_ry.y = 50;
			addChild(_ry);
			
			_rz = new AwaySliderControl("rz");
			_rz.addEventListener(Event.CHANGE, changeHandle);
			_rz.x = 103;
			_rz.y = 75;
			addChild(_rz);
			
			_copy = new TextField();
			_copy.width = 300;
			_copy.height = 20;
			_copy.type = TextFieldType.INPUT;
			_copy.x = 24;
			_copy.y = 150;
			addChild(_copy);
		}
		
		private function changeHandle(e:Event):void 
		{
			_px.tf.text = _currentItem.x.toFixed();
			_py.tf.text = _currentItem.y.toFixed();
			_pz.tf.text = _currentItem.z.toFixed();
			_rx.tf.text = _currentItem.rotationX.toFixed();
			_ry.tf.text = _currentItem.rotationY.toFixed();
			_rz.tf.text = _currentItem.rotationZ.toFixed();
			
			_copy.text = "x:" + _px.tf.text + ",y:" + _py.tf.text + ",z:" + _pz.tf.text + ",rx:" + _rx.tf.text + ",ry:" + _ry.tf.text + ",rz:" + _rz.tf.text;
		}
		
		private function createButtons(items:Array):void
		{
			var count:int = 0;
			for each(var item:Object3D in items)
			{
				var b:AwayItemButton = new AwayItemButton();
				b.addEventListener(MouseEvent.CLICK, itemButtonClickHandle);
				b.setButton(item);
				b.x = 201;
				b.y = count * 21;
				addChild(b);
				_items.push(b);
				count++;
			}
			
			toggleButtons(false);
		}
		
		private function itemButtonClickHandle(e:MouseEvent):void 
		{
			setCurrentItem(e.currentTarget.item);
		}
		
		private function setCurrentItem(item:Object3D):void
		{
			_currentItem = item;
			_px.item = _currentItem;
			_py.item = _currentItem;
			_pz.item = _currentItem;
			_rx.item = _currentItem;
			_ry.item = _currentItem;
			_rz.item = _currentItem;
			_title_txt.text = _currentItem.name;
			toggleButtons(false);
			changeHandle(null);
		}
		
		private function menuClickHandle(e:MouseEvent):void 
		{
			toggleButtons(true);
		}
		
		private function toggleButtons(vis:Boolean):void
		{
			for (var i:int = 0; i < _items.length; i++)
			{
				_items[i].visible = vis;
			}
		}
	}
}