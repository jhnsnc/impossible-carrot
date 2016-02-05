package scenes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SummaryScreen extends Sprite implements IScene
	{
		private static const RANKS:Array = [	{maximum:20, title:"Supreme Carrot Commander"},
												{maximum:25, title:"Admiral Carrot of Apiales"},
												{maximum:35, title:"Commodore Carrot"},
												{maximum:50, title:"Captain Carrot"},
												{maximum:65, title:"Space Lieutenant Carrot"},
												{maximum:80, title:"Carrot Cadet"},
												{maximum:95, title:"Carrot Juice"},
												{maximum:120, title:"Could've been a V8"},
												{maximum:999, title:"Are you trying to get hit?"}
			];
		
		private static const TIP_MESSAGES:Array = [	"The patterns are the same every time you play. Watch carefully and you can improve your score.",
													"Some patterns have safe spots where you can remain still and not get hit for several seconds.",
													"Try only moving only horizontally or vertically to make some patterns easier to dodge.",
													"A bullet barely hitting the carrot ship does not necessarily cause a collision.",
													"For some patterns, holding shift to move slower can make it easier to dodge bullets.",
													"Try it again with the music twice as loud. It totally helps... maybe."
			];
		
		private static const FADE_STEP:Number = 0.02;
		
		private var content:MovieClip;
		
		private var isFading:Boolean;
		private var numCollisions:uint;
		
		public function SummaryScreen(pCollisions:uint)
		{
			numCollisions = pCollisions;
			
			content = new ImpossibleCarrotAssets.summaryScreen();
			this.addChild(content);
			setup();
		}
		
		private function setup():void
		{
			//initialize variables (everything not controlled by the timeline)
			content.gotoAndStop(1);
			
			isFading = false;
			
			content.blackRect.mouseEnabled = false;
			content.blackRect.alpha = 0.0;
			
			//set text pieces
			content.rank.text = getRank(numCollisions);
			content.collisions.text = numCollisions + " collisions";
			content.goal.text = getGoal(numCollisions);
			content.tip.text = getRandomTip();
			
			//set up listeners
			content.backToTitleScreen.buttonMode = true;
			content.backToTitleScreen.mouseChildren = false;
			content.backToTitleScreen.addEventListener(MouseEvent.CLICK, backToMain, false, 0, true);
		}
		
		private function getRank(pCollisions:uint):String
		{
			var len:uint = RANKS.length;
			for (var i:uint = 0; i < len; i++)
			{
				if ( pCollisions <= RANKS[i].maximum )
				{
					return RANKS[i].title;
				}
			}
			return RANKS[RANKS.length-1].title;
		}
		
		private function getGoal(pCollisions:uint):String
		{
			if ( pCollisions <= 20 ) //foobar solution
			{
				return "highest rank achieved!!!";
			}
			for (var i:uint = RANKS.length-1; i >= 0; i--)
			{
				if ( pCollisions > RANKS[i].maximum )
				{
					return RANKS[i].maximum + " collisions or fewer";
				}
			}
			return "highest rank achieved!!!";
		}
		
		private function getRandomTip():String
		{
			return TIP_MESSAGES[ Math.floor(Math.random() * TIP_MESSAGES.length) ];
		}
		
		private function backToMain(evt:Event = null):void
		{
			content.backToTitleScreen.removeEventListener(MouseEvent.CLICK, backToMain, false);
			content.backToTitleScreen.mouseEnabled = false;
			
			isFading = true;
			content.blackRect.mouseEnabled = true;
			
			content.addEventListener(Event.ENTER_FRAME, updateScene, false, 0, true);
		}
		
		private function updateScene(evt:Event = null):void
		{
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
				return false;
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