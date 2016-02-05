package scenes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BasicScene extends Sprite implements IScene
	{
		private static const FADE_STEP:Number = 0.02;
		
		private var content:MovieClip;
		
		private var isFading:Boolean;
		
		public function BasicScene(pClass:Class)
		{
			content = new pClass();
			this.addChild(content);
			setup();
		}
		
		private function setup():void
		{
			isFading = false;
			
			content.blackRect.mouseEnabled = false;
			content.blackRect.alpha = 0.0;
			
			content.btnSkip.addEventListener(MouseEvent.CLICK, skipScene, false, 0, true);
			content.addEventListener(Event.ENTER_FRAME, updateScene, false, 0, true);
		}
		
		private function skipScene(evt:Event = null):void
		{
			content.btnSkip.removeEventListener(MouseEvent.CLICK, skipScene, false);
			
			isFading = true;
			content.btnSkip.mouseEnabled = false;
			content.blackRect.mouseEnabled = true;
		}
		
		private function updateScene(evt:Event = null):void
		{
			if ( content.currentFrame >= content.totalFrames )
			{
				content.stop();
			}
			
			//check for fade out
			if ( isFading )
			{
				content.blackRect.alpha += FADE_STEP;
			}
		}
		
		public function isComplete():Boolean
		{
			if ( isFading )
			{
				return ( content.blackRect.alpha >= 1.0 );				
			}
			else
			{
				return ( content.currentFrame >= content.totalFrames );
			}
		}
		
		public function getRemainingFrames():uint
		{
			if ( isFading )
			{
				return ( (1.0-content.blackRect.alpha) * 100 );
			}
			else
			{
				return ( content.totalFrames - content.currentFrame );
			}
		}
	}
}