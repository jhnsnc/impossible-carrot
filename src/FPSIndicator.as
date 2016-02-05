package
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class FPSIndicator extends DebugIndicator
	{
		private var _timeLastFrame:uint;
		private var _recentFpsValues:Array;
		
		public function FPSIndicator(fontSize:Number = 24, fontColor:uint = 0x00FF00)
		{
			super("FPS", fontSize, fontColor);
			
			_timeLastFrame = getTimer();
			_recentFpsValues = new Array();
			
			var format:TextFormat = new TextFormat();
			format.size = fontSize;
			format.color = fontColor;
			this.defaultTextFormat = format;
			
			this.width = 10 * fontSize;
			this.selectable = false;
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(evt:Event):void
		{
			//find the time elapsed since last frame (in milliseconds)
			var timeElapsed:uint = getTimer() - _timeLastFrame;
			
			//update FPS indicator
			var fps:Number = 1000 / timeElapsed;
			if ( _recentFpsValues.length > 30 ) { _recentFpsValues.shift(); }
			_recentFpsValues.push(fps);
			var avg:Number = 0;
			for (var i:uint = 0; i < _recentFpsValues.length; i++)
			{
				avg += _recentFpsValues[i];
			}
			avg /= _recentFpsValues.length;
			this.updateDisplay( String( Math.floor(avg) ) );
			
			//increment time
			_timeLastFrame = getTimer();
		}
	}
}