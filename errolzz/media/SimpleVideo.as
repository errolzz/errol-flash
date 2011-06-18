package com.errolzz.media
{
	import com.errolzz.events.VideoEvent;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class SimpleVideo extends Sprite
	{
		private var _video:Video;
		private var _netStream:NetStream;
		private var _netConnection:NetConnection;
		private var _loadProgress:Number;
		private var _playHeadTime:Number;
		private var _contentPath:String;
		private var _autoPlay:Boolean;
		private var _looping:Boolean;
		private var _metaData:Object;
		private var _autoSize:Boolean;
		
		public function SimpleVideo(width:int, height:int, contentPath:String, autoPlay:Boolean = false, autoSize:Boolean = false, smoothing:Boolean = false, looping:Boolean = false) 
		{
			_contentPath = contentPath;
			_autoPlay = autoPlay;
			_looping = looping;
			_autoSize = autoSize;
			
			_video = new Video(width, height);
			addChild(_video);
			
			_netConnection = new NetConnection();
		}
		
		public function playNewVideo(contentPath:String):void
		{
			closeStream();
			
			this.removeEventListener(Event.ENTER_FRAME, videoProgress);
			this.addEventListener(Event.ENTER_FRAME, videoProgress);
			
			_contentPath = contentPath;
			_netStream.play(_contentPath);
		}
		
		public function startup():void
		{
			_netConnection.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
			_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_netConnection.connect( null );
		}
		
		public function pause():void
		{
			if(_netStream) _netStream.pause();
		}
		
		public function resume():void
		{
			if(_netStream) _netStream.resume();
		}
		
		public function seek(seconds:Number):void
		{
			if(_netStream) _netStream.seek(seconds);
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			switch( e.info.code )
			{
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
				case "NetStream.Play.Stop" :
					onNetStreamStop();
					break;
			}
		}
		
		private function connectStream():void
		{
			_netStream = new NetStream(_netConnection);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_netStream.client = this;
			_video.attachNetStream(_netStream);
			
			if(_autoPlay == true) playNewVideo(_contentPath);
		}
		
		private function onNetStreamStop():void
		{
			_netStream.seek(0);
			if (_looping == false) 
			{
				_netStream.pause();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				////trace("play");
			}
			
		}
		
		public function onMetaData(data:Object):void 
		{
			_metaData = data;
			
			if (_autoSize == true)
			{
				_video.width = _metaData.width;
				_video.height = _metaData.height;
			}
			dispatchEvent(new VideoEvent(VideoEvent.META_DATA_READY));
		}
		
		public function onXMPData(data:Object):void
		{
			
		}
		
		public function onCuePoint(cuePoint:Object):void 
		{
			
		}
		
		private function videoProgress(e:Event):void
		{
			_loadProgress = _netStream.bytesLoaded / _netStream.bytesTotal
			_playHeadTime = _netStream.time;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		private function closeStream():void
		{
			_loadProgress = 0;
			try {
				_netStream.close();
			}catch (e:Error) {
				//no stream opened
			}
		}
		
		private function closeNetConnection():void 
		{
			try {
				_netConnection.close();
			}catch (e:Error) {
				//no connection opened
			}
		}
		
		public function die():void
		{
			closeStream();
			closeNetConnection();
			if (_netStream)
			{
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			}
			if (_netConnection)
			{
				_netConnection.removeEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
				_netConnection.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			}
			this.removeEventListener(Event.ENTER_FRAME, videoProgress);
		}
		
		public function get volume():Number
		{
			return _netStream.soundTransform.volume;
		}
		
		public function set volume( v:Number ):void
		{
			if(_netStream) _netStream.soundTransform = new SoundTransform( v );
		}
		
		//Error catchers
		private function onSecurityError(e:Event):void { trace(e.toString()); }
		
		private function onAsyncError(e:AsyncErrorEvent):void { trace(e.toString()); }
		
		public function get playHeadTime():Number { return _playHeadTime; }
		
		public function get loadProgress():Number { return _loadProgress; }
		
		public function get contentPath():String { return _contentPath; }
		
		public function get metaData():Object { return _metaData; }
		
		public function get video():Video { return _video; }
	}

}