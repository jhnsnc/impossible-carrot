package
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import myLib.ui.MovieApplication;

	public class SpriteManager
	{
		private static var _instance:SpriteManager;
		
		private var _playerSprite:Object;
		private var _enemySprites:Array;
		private var _starSprites:Array;
		
		public function SpriteManager(singleton:SingletonEnforcer)
		{
			if(!singleton) throw new Error("You cannot instantiate the SpriteManager class using the constructor. Please use SpriteManager.getInstance() instead.");
			initialize();
		}
		
		static public function getInstance():SpriteManager
		{
			if(!_instance)
			{
				_instance = new SpriteManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function initialize(evt:Event = null):void
		{
			var i:uint, j:uint;
			
			//store player sprite
			_playerSprite = new Object();
			_playerSprite.arrBitmapData = new Array();
			var shipBD:BitmapData;
			var shipMC:MovieClip = new ImpossibleCarrotAssets.playerSprite();
			for (var x:uint = 1; x <= 5; x++)
			{
				shipMC.gotoAndStop(x);
				shipBD = new BitmapData(shipMC.width, shipMC.height, true, 0x000000);
				shipBD.draw(shipMC);
				_playerSprite.arrBitmapData.push(shipBD);
			}
			_playerSprite.xOffset = ImpossibleCarrotAssets.playerInfo.xOffset;
			_playerSprite.yOffset = ImpossibleCarrotAssets.playerInfo.yOffset;
			
			//store all enemy sprites
			_enemySprites = new Array();
			
			var enemyClasses:Array = ImpossibleCarrotAssets.enemyClasses;
			for (i = 0; i < enemyClasses.length; i++)
			{
				var enemyObj:Object = new Object();
				enemyObj.id = enemyClasses[i].id;
				enemyObj.collisionRadius = enemyClasses[i].collisionRadius;
				enemyObj.arrBitmapData = new Array();
				var enemyBD:BitmapData;
				if ( enemyClasses[i].singleFrame ) //prepare bitmapData (single frame)
				{
					enemyObj.singleFrame = true;
					var enemySP:Sprite = new enemyClasses[i]["asset"]();
					enemyBD = new BitmapData(enemySP.width, enemySP.height, true, 0x000000);
					enemyBD.draw(enemySP);
					enemyObj.arrBitmapData.push(enemyBD);
				}
				else	//prepare bitmapData (multiple frames)
				{
					enemyObj.singleFrame = false;
					var enemyMC:MovieClip = new enemyClasses[i]["asset"]();
					enemyObj.totalFrames = enemyMC.totalFrames;
					enemyObj.keyframes = new Array();
					for (j = 0; j < enemyClasses[i].keyframes.length; j++)
					{
						enemyMC.gotoAndStop(enemyClasses[i].keyframes[j]);
						enemyBD = new BitmapData(enemyMC.width, enemyMC.height, true, 0x000000);
						enemyBD.draw(enemyMC);
						enemyObj.arrBitmapData.push(enemyBD);
						enemyObj.keyframes.push(enemyClasses[i].keyframes[j]);
					}
				}
				enemyObj.xOffset = enemyClasses[i].xOffset;
				enemyObj.yOffset = enemyClasses[i].yOffset;
				
				_enemySprites.push(enemyObj);
			}
			
			//store all star sprites
			_starSprites = new Array();
			
			var starClasses:Array = ImpossibleCarrotAssets.starClasses;
			for (i = 0; i < starClasses.length; i++)
			{
				var starObj:Object = new Object();
				starObj.arrBitmapData = new Array();
				var starBD:BitmapData;
				if ( starClasses[i].singleFrame ) //prepare bitmapData (single frame)
				{
					starObj.singleFrame = true;
					var starSP:Sprite = new starClasses[i]["asset"]();
					starObj.totalFrames = 1;
					starBD = new BitmapData(starSP.width, starSP.height, true, 0x000000);
					starBD.draw(starSP);
					starObj.arrBitmapData.push(starBD);
				}
				else	//prepare bitmapData (multiple frames)
				{
					starObj.singleFrame = false;
					var starMC:MovieClip = new starClasses[i]["asset"]();
					starObj.totalFrames = starMC.totalFrames;
					starObj.keyframes = new Array();
					for (j = 0; j < starClasses[i].keyframes.length; j++)
					{
						starMC.gotoAndStop(starClasses[i].keyframes[j]);
						starBD = new BitmapData(7, 7, true, 0x000000);
						starBD.draw(starMC);
						starObj.arrBitmapData.push(starBD);
						starObj.keyframes.push(starClasses[i].keyframes[j]);
					}
				}
				
				_starSprites.push(starObj);
			}
		}
		
		public function getEnemySprite(id:String, frame:uint):Object
		{
			//determine which enemy sprite to use (i)
			var i:uint;
			for (i = 0; i < _enemySprites.length; i++)
			{
				if ( _enemySprites[i].id == id )
				{
					break;
				}
			}
			
			if ( _enemySprites[i].singleFrame ) //only one frame for this assetID
			{
				return {bd:_enemySprites[i].arrBitmapData[0], xOffset:_enemySprites[i].xOffset, yOffset:_enemySprites[i].yOffset};
			}
			else //several frames for this assetID
			{
				//determine which bitmap data to use for enemy at index i (j)
				var j:uint;
				for (j = 0; j < _enemySprites[i].keyframes.length-1; j++)
				{
					if ( _enemySprites[i].keyframes[j] <= frame && _enemySprites[i].keyframes[j+1] > frame )
					{
						break;
					}
				}
				
				return {bd:_enemySprites[i].arrBitmapData[j], xOffset:_enemySprites[i].xOffset, yOffset:_enemySprites[i].yOffset};
			}
		}
		
		public function getEnemyCollisionRadius(id:String):Number
		{
			//determine which enemy sprite to use (i)
			var i:uint;
			for (i = 0; i < _enemySprites.length; i++)
			{
				if ( _enemySprites[i].id == id )
				{
					break;
				}
			}
			
			return _enemySprites[i].collisionRadius;
		}
		
		public function getEnemyTotalFrames(id:String):uint
		{
			//determine which enemy sprite to use (i)
			var i:uint;
			for (i = 0; i < _enemySprites.length; i++)
			{
				if ( _enemySprites[i].id == id )
				{
					break;
				}
			}
			
			return _enemySprites[i].totalFrames;
		}
		
		public function getPlayerSprite(frame:uint):Object
		{
			return {bd:_playerSprite.arrBitmapData[frame-1], xOffset:_playerSprite.xOffset, yOffset:_playerSprite.yOffset};
		}
		
		public function getStarSprite(classIdx:uint, frame:uint):Object
		{
			if (classIdx==1 || classIdx==2) //hard-coded (either of the static star classes)
			//if ( _enemySprites[classIdx].singleFrame ) //only one frame for this assetID
			{
				return {bd:_starSprites[classIdx].arrBitmapData[0]};
			}
			else //several frames for this assetID
			{
				//determine which bitmap data to use for enemy at index i (j)
				var j:uint;
				for (j = 0; j < _starSprites[classIdx].keyframes.length-1; j++)
				{
					if ( _starSprites[classIdx].keyframes[j] <= frame && _starSprites[classIdx].keyframes[j+1] > frame )
					{
						break;
					}
				}
				
				return {bd:_starSprites[classIdx].arrBitmapData[j]};
			}
		}
		
		public function getStarTotalFrames(classIdx:uint):uint
		{
			return _starSprites[classIdx].totalFrames;
		}
	}
}

class SingletonEnforcer
{
	public function SingletonEnforcer(){};
}