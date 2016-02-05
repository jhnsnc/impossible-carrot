package
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Background
	{
		private const NUM_STARS:uint = 35;
		private const TIME_TO_BOTTOM:Number = 130;
		
		private var _spriteManager:SpriteManager;
		
		private var _stars:Array;
		
		public function Background()
		{
			_stars = new Array();
			
			buildContent();
		}
		
		private function buildContent():void
		{
			_spriteManager = SpriteManager.getInstance();
			
			//initialize the star array
			_stars = new Array();
			for (var i:uint = 0; i < NUM_STARS; i++) {
				var rand:Number = Math.random();
				var percent:Number = 0;
				for (var classIdx:uint = 0; classIdx < ImpossibleCarrotAssets.starClasses.length; classIdx++) {
					if (rand < percent + ImpossibleCarrotAssets.starClasses[classIdx].chance) {
						//add a star to the array
						var star:Object = new Object();
						star.assetIdx = classIdx;
						star.x = Main.W * Math.random();
						star.y = Main.H * Math.random();
						star.frame = 1;
						star.totalFrames = _spriteManager.getStarTotalFrames(classIdx);
						star.speed = (0.5 + Math.random()) * Main.H / TIME_TO_BOTTOM; //50-150% of the speed to cross screen in TIME_TO_BOTTOM frames
						_stars.push(star);
						break;
					} else {
						percent += ImpossibleCarrotAssets.starClasses[classIdx].chance;
					}
				}
			}
		}
		
		public function tick():void
		{
			for (var i:uint = 0; i < _stars.length; i++)
			{
				_stars[i].y += _stars[i].speed;
				_stars[i].frame++;
				if ( _stars[i].frame > _stars[i].totalFrames )
				{
					_stars[i].frame = 1;
				}
				
				if ( _stars[i].y > Main.H + 10 ) //star out of bounds; refresh
				{
					var rand:Number = Math.random();
					var percent:Number = 0;
					for (var classIdx:uint = 0; classIdx < ImpossibleCarrotAssets.starClasses.length; classIdx++) {
						if (rand < percent + ImpossibleCarrotAssets.starClasses[classIdx].chance) {
							//add a star to the array
							var star:Object = new Object();
							star.assetIdx = classIdx;
							star.x = Main.W * Math.random();
							star.y = -5;
							star.frame = 1;
							star.totalFrames = _spriteManager.getStarTotalFrames(classIdx);
							star.speed = (0.5 + Math.random()) * Main.H / TIME_TO_BOTTOM; //50-150% of the speed to cross screen in TIME_TO_BOTTOM frames
							_stars[i] = star;
							break;
						} else {
							percent += ImpossibleCarrotAssets.starClasses[classIdx].chance;
						}
					}
				}
			}
		}
		
		public function getBitmapData():BitmapData
		{
			var bd:BitmapData = new BitmapData(Main.W, Main.H, false, 0x000000);
			
			for (var i:uint = 0; i < _stars.length; i++)
			{
				var starBD:BitmapData = _spriteManager.getStarSprite(_stars[i].assetIdx, _stars[i].frame).bd;
				bd.copyPixels(starBD, new Rectangle(0, 0, starBD.width, starBD.height), new Point(_stars[i].x, _stars[i].y), null, null, true);
			}
			
			return bd; 
		}
	}
}