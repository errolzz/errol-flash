package com.errolzz.media 
{
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class AudioPlayer extends Object
	{
		private static var _instance:AudioPlayer;
		
		private var _channels:Array;
		private var _sounds:Vector.<Sound>;
		private var _transforms:Vector.<SoundTransform>;
		private var _pauseTimes:Vector.<Number>;
		private var _mutedChannels:Vector.<int>
		
		public function AudioPlayer() 
		{
			if(_instance)
			{
				throw new Error("Cannot instantiate new AudioPlayer object.");
			}
			
			//_channels = new Vector.<SoundChannel>();
			_channels = [];
			_sounds = new Vector.<Sound>();
			_transforms = new Vector.<SoundTransform>();
			_pauseTimes = new Vector.<Number>();
			_mutedChannels = new Vector.<int>();
			
			_channels[0] = new SoundChannel();
			_channels[1] = new SoundChannel();
			_transforms[0] = new SoundTransform(0);
			_transforms[1] = new SoundTransform(0);
		}
		
		/**
		 * Loads and plays and external sound file.
		 * @param	soundPath Path to sound file.
		 * @param	channel Channel 0 for music, others for effects.
		 * @param	buffer 
		 * @param	volume 
		 * @param	loops 
		 */
		public function playSoundFile(soundPath:String, channel:int = 0, buffer:int = 1000, volume:Number = 1, loops:int = 1):void
		{
			if (_channels[channel] == null) 
			{
				_channels[channel] = new SoundChannel();
			}
			
			_transforms[channel] = new SoundTransform(volume);
			_sounds[channel] = new Sound(new URLRequest(soundPath), new SoundLoaderContext(buffer, true));
			_channels[channel].stop();
			
			if(checkChannelMuted(channel) == false)
			{
				_channels[channel] = _sounds[channel].play(0, loops, _transforms[channel]);
			}
		}
		
		/**
		 * Creates and plays a sound file from the library.
		 * @param	sound Sound object from library.
		 * @param	channel
		 * @param	volume
		 * @param	loops
		 */
		public function playSoundObject(sound:Sound, channel:int = 1, volume:Number = 1, loops:int = 1, startTime:Number = 0):void
		{
			if (_channels[channel] == null) 
			{
				_channels[channel] = new SoundChannel();
			}
			
			_transforms[channel] = new SoundTransform(volume);
			_sounds[channel] = sound;
			_channels[channel].stop();
			
			if (checkChannelMuted(channel) == false)
			{
				_channels[channel] = sound.play(startTime, loops, _transforms[channel]);
			}
		}
		
		/**
		 * Fades channel 0 to a new volume level.
		 * @param	volume 
		 * @param	duration 
		 */
		public function fadeVolumeTo(channel:int, volume:Number, duration:Number = 1, pauseOnComplete:Boolean = false, muteOnComplete:Boolean = false):void
		{
			try {
				TweenLite.to(_transforms[channel], duration, { volume:volume, onUpdate:fadeUpdate, onUpdateParams:[channel], onComplete:fadeComplete, onCompleteParams:[channel, pauseOnComplete, muteOnComplete] } );
			}catch (e:Error) {
				
			}
		}
		
		private function fadeUpdate(channel:int):void
		{
			_channels[channel].soundTransform = _transforms[channel];
		}
		
		private function fadeComplete(channel:int, pause:Boolean, mute:Boolean):void
		{
			if (pause == true)
			{
				pauseChannel(channel);
			}
			if (mute == true)
			{
				muteChannel(channel);
				//trace("muting channel: " + channel);
			}
		}
		
		/**
		 * Stops all sounds and timers.
		 * Clears out all channels, transforms, pause times, and sounds.
		 */
		public function reset():void
		{
			for (var i:int = 0; i < _channels.length; i++) 
			{
				_channels[i].stop();
			}
			_channels.length = 0;
			_sounds.length = 0;
			_transforms.length = 0;
			_pauseTimes.length = 0;
			_mutedChannels.length = 0;
		}
		
		/**
		 * Pauses channel and adds it to the muted channels array.
		 * @param	channel
		 */
		public function muteChannel(channel:int):void
		{
			unMuteChannel(channel);
			_mutedChannels.push(channel);
		}
		
		/**
		 * Removes a channel from the muted channels array. Does NOT start playing channel again
		 * @param	channel
		 */
		public function unMuteChannel(channel:int):void
		{
			for (var i:int = 0; i < _mutedChannels.length; i++) 
			{
				if (_mutedChannels[i] == channel) 
				{
					_mutedChannels.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Pauses an audio channel.
		 * @param	channel
		 */
		public function pauseChannel(channel:int = 0):void
		{
			_pauseTimes[channel] = _channels[channel].position;
			_channels[channel].stop();
		}
		
		/**
		 * Unpauses a channel and starts playing it from the point it was paused at.
		 * @param	channel
		 * @param	loops
		 * @param	volume
		 */
		public function unPauseChannel(channel:int = 0, loops:int = 1, volume:int = 1):void
		{
			var startTime:Number;
			try {
				startTime = _pauseTimes[channel];
			}catch (e:Error) {
				startTime = 0;
			}
			_transforms[channel].volume = volume;
			_channels[channel] = _sounds[channel].play(startTime, loops, _transforms[channel]);
		}
		
		/**
		 * Stops an audio channel.
		 * @param	channel
		 */
		public function stop(channel:int = 0):void
		{
			_channels[channel].stop();
		}
		
		private function checkChannelMuted(channel:int):Boolean
		{
			for (var i:int = 0; i < _mutedChannels.length; i++) 
			{
				if (channel == _mutedChannels[i])
				{
					return true;
				}
			}
			return false;
		}
		
		static public function get instance():AudioPlayer 
		{
			if(_instance == null)
			{
				_instance = new AudioPlayer();
			}
			return _instance;
		}
	}

}