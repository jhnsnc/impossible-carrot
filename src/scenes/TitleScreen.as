package scenes 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class TitleScreen extends Sprite implements IScene
	{
		private var content:MovieClip;
		private var activeHoverArea:uint;

		public function TitleScreen()
		{
			content = new ImpossibleCarrotAssets.titleScreen();
			this.addChild(content);
			setup();
		}

		private function setup():void
		{
			//initialize variables (everything not controlled by the timeline
			content.gotoAndStop("main");
			activeHoverArea = 0;
			
			//set up listeners
			content.addEventListener(Event.ENTER_FRAME, updateHoverPosition);
			content.startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			content.credits.addEventListener(MouseEvent.CLICK, onCredits);
			content.more.addEventListener(MouseEvent.CLICK, onMoreClicked);
			content.startGame.buttonMode = true;
			content.startGame.mouseChildren = false;
			content.credits.buttonMode = true;
			content.credits.mouseChildren = false;
			content.more.buttonMode = true;
			content.more.mouseChildren = false;
		}

		private function updateHoverPosition(evt:Event = null):void
		{
			if ( content.mouseY >= 160 && content.mouseY < 190 ) { //on "start game"
				activeHoverArea = 1;
			} else if ( content.mouseY >= 190 && content.mouseY < 220 ) { //on "credits"
				activeHoverArea = 2;
			} else if ( content.mouseY >= 220 && content.mouseY < 250 ) { //on "more"
				activeHoverArea = 3;
			} else if ( content.mouseY < 160 ) { //above all clickable options
				activeHoverArea = 0;
			} else { //below all clickable options
				activeHoverArea = 99;
			}
			
			moveSelector(activeHoverArea);
		}

		private function onStartGame(evt:Event = null):void
		{
			//clean up listeners
			content.removeEventListener(Event.ENTER_FRAME, updateHoverPosition);
			content.startGame.removeEventListener(MouseEvent.CLICK, onStartGame);
			content.credits.removeEventListener(MouseEvent.CLICK, onCredits);
			content.more.removeEventListener(MouseEvent.CLICK, onMoreClicked);
			
			//start transition
			content.gotoAndPlay("transitionOut");
			content.addEventListener(Event.ENTER_FRAME, checkForLastFrame);
		}

		private function checkForLastFrame(evt:Event = null):void
		{
			if ( content.currentFrame == content.totalFrames )
			{
				content.removeEventListener(Event.ENTER_FRAME, checkForLastFrame);
				content.stop();
			}
		}

		private function onCredits(evt:Event = null):void
		{
			content.startGame.removeEventListener(MouseEvent.CLICK, onStartGame);
			content.credits.removeEventListener(MouseEvent.CLICK, onCredits);
			content.more.removeEventListener(MouseEvent.CLICK, onMoreClicked);
			content.removeEventListener(Event.ENTER_FRAME, updateHoverPosition);
			content.gotoAndStop("credits");
			content.btnBack.addEventListener(MouseEvent.CLICK, backToMain);
		}
		
		private function backToMain(evt:Event = null):void
		{
			content.btnBack.removeEventListener(MouseEvent.CLICK, backToMain);
			content.gotoAndStop("main");
			content.startGame.addEventListener(MouseEvent.CLICK, onStartGame);
			content.credits.addEventListener(MouseEvent.CLICK, onCredits);
			content.more.addEventListener(MouseEvent.CLICK, onMoreClicked);
			content.addEventListener(Event.ENTER_FRAME, updateHoverPosition);
			content.startGame.buttonMode = true;
			content.startGame.mouseChildren = false;
			content.credits.buttonMode = true;
			content.credits.mouseChildren = false;
			content.more.buttonMode = true;
			content.more.mouseChildren = false;
		}
		
		private function onMoreClicked(evt:Event = null):void
		{
			navigateToURL(new URLRequest("http://www.design4learning.net/"), "_blank");
		}
		
		private function moveSelector(position:uint):void
		{
			var newY:Number;
			if ( position == 1 ) {
				newY = 175;
			} else if ( position == 2 ) {
				newY = 205;
			} else if ( position == 3 ) {
				newY = 235;
			} else {
				newY = 335;
			}
			
			content.selector1.y = newY;
			content.selector2.y = newY;
		}
		
		public function isComplete():Boolean
		{
			return ( content.currentFrame >= content.totalFrames );
		}
		
		public function getRemainingFrames():uint
		{
			return ( content.totalFrames - content.currentFrame );
		}
	}
}