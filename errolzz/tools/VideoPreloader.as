package com.errolzz.tools 
{
	import flash.display.Loader;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class VideoPreloader extends EventDispatcher
	{
		private var _videoPaths:Array;
		private var _numberOfVideos:int;
		private var _index:int;
		private var _video:Video;
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		private var _timer:Timer;
		private var _percentToPreload:Number;
		private var _completeFunction:Function;
		private var _progressFunction:Function;
		
		public function VideoPreloader(videoPaths:Array, percentToPreload:Number = .5, completeFunction:Function = null, progressFunction:Function = null) 
		{
			if (percentToPreload > 1)
			{
				throw new Error("percentToPreload must be a value between 0 and 1.");
			}
			
			_index = 0;
			
			_videoPaths = videoPaths;
			_numberOfVideos = _videoPaths.length;
			_percentToPreload = percentToPreload;
			_completeFunction = completeFunction;
			_progressFunction = progressFunction;
			
			_timer = new Timer(20);
			_timer.addEventListener(TimerEvent.TIMER, timerTick);
			_timer.start();
			
			_netConnection = new NetConnection();
			_netConnection.connect(null);
			
			_netStream = new NetStream( _netConnection );
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onXMPData);
			_netStream.soundTransform = new SoundTransform(0);
			_netStream.play( _videoPaths[0] );
			_netStream.pause();
			
			_video = new Video();
			_video.attachNetStream( _netStream );
		}
		
		private function timerTick(e:TimerEvent):void 
		{
			if (_netStream)
			{
				var percOfPerc:Number = (_netStream.bytesLoaded / _netStream.bytesTotal) / _percentToPreload;
				if (_progressFunction != null) _progressFunction(percOfPerc);
				
				if (_netStream.bytesLoaded >= _netStream.bytesTotal * _percentToPreload)
				{
					_index++;
					
					//loads the next
					if (_index < _numberOfVideos)
					{
						startNewVideo(_videoPaths[_index]);
					}
					//finished preloading all items
					else
					{
						if(_completeFunction != null) _completeFunction();
						die();
					}
				}
			}
		}
		
		private function startNewVideo(videoPath:String):void
		{
			_netStream.play( videoPath );
			_netStream.pause();
		}
		
		private function onXMPData(e:AsyncErrorEvent):void 
		{
			//these two handlers...
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			//...are quieter than Britney Spears' dietitian
		}
		
		public function die():void
		{
			_video = null;
			_netStream.close();
			_netConnection.close();
			_netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onXMPData);
			_timer.removeEventListener(TimerEvent.TIMER, timerTick);
			_timer = null;
		}
	}

}