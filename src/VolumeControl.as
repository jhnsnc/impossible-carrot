package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class VolumeControl extends Sprite
	{
		private var _volume:Number;
		private var _button:MovieClip;
		
		public function VolumeControl()
		{
			_button = new ImpossibleCarrotAssets.volumeControlButton();
			this.addChild( _button );
			
			_volume = 0.75;
			_button.gotoAndStop(4);
			
			_button.mouseChildren = false;
			_button.mouseEnabled = true;
			_button.buttonMode = true;
			_button.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			super();
		}
		
		private function onClick(evt:Event = null):void
		{
			_volume -= 0.25;
			if ( _volume < 0.0 )
			{
				_volume = 1.0;
			}
			
			_button.gotoAndStop( 1 + (_volume*4) );
			
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function get volume():Number { return _volume; }
	}
}