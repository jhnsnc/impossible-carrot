package
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DebugIndicator extends TextField
	{
		private var _label:String;
		
		public function DebugIndicator(label:String, fontSize:Number = 24, fontColor:uint = 0x00FF00)
		{
			super();
			
			_label = label;
			
			var format:TextFormat = new TextFormat();
			format.size = fontSize;
			format.color = fontColor;
			this.defaultTextFormat = format;
			
			this.width = 10 * fontSize;
			this.selectable = false;
			
			this.updateDisplay("");
		}
		
		public function updateDisplay(msg:String):void
		{
			this.text = _label + ": " + msg;
		}
	}
}