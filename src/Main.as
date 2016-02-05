package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import net.design4learning.MusicTracker;
	
	import scenes.BasicScene;
	import scenes.IScene;
	import scenes.SummaryScreen;
	import scenes.TitleScreen;
	
	[SWF (width = 800, height = 600, frameRate = 60, backgroundColor = 0x666666)]
	public class Main extends Sprite
	{
		public static const W:Number = 400;
		public static const H:Number = 300;
		
		public static const FINAL_BEAT:uint = 275;
		
		private var _functionQueue:Array;
		private var _timeLastFrame:uint;
		
		private var _timeLastBeat:uint;
		private var _musicTracker:MusicTracker;
		private var _musicStarted:Boolean;
		private var _menuSoundChannel:SoundChannel;
		private var _volumeControl:VolumeControl;
		private var _volumeMultiplier:Number;
		private var _useVolumeMultiplier:Boolean;
		private var _menuMode:Boolean;
		
		private var _activeScene:Sprite;
		private var _onSceneComplete:Function;
		private var _hasShownScene0:Boolean;
		
		private var _fpsIndicator:FPSIndicator;
		private var _objectsIndicator:DebugIndicator;
		private var _objectsOnScreen:uint;
		private var _collisionsIndicator:DebugIndicator;
		private var _collisionCount:uint;
		private var _recentlyHit:Boolean;
		private const FLICKER_DURATION:uint = 14; //the number of times the player ship will flicker when hit
		private var _flickerCountdown:uint;
		private const FLICKER_STEP_DURATION:uint = 2; //the number of times the player ship will flicker when hit
		private var _flickerStepCountdown:uint;
		
		private var _eventScript:Array;
		
		private var _screenBitmap:Bitmap;
		private var _screenBD:BitmapData;
		private var _bg:Background;
		
		private const NUM_ENEMY_LAYERS:uint = 5;
		private var _enemies:Array;
		private var _spriteManager:SpriteManager;
		private var _player:Player;
		
		public function Main()
		{
			Security.allowDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0 , true);
		}
		
		public function init(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.scaleX = 2;
			this.scaleY = 2;
			
			//initializations
			_functionQueue = new Array();
			_collisionCount = 0;
			
			_recentlyHit = false;
			_menuMode = true;
			
			_timeLastFrame = getTimer();
			_timeLastBeat = getTimer();
			_musicStarted = false;
			
			_hasShownScene0 = false;
			_useVolumeMultiplier = false;
			
			//set up the game
			buildGameContent();
			//startGame(); will be called after _musicTracker is ready
		}
		
		private function buildGameContent():void
		{
			//add background
			_bg = new Background();
			
			//set up bitmap
			_screenBitmap = new Bitmap(null, "auto", true);
			this.addChild( _screenBitmap );
			
			_spriteManager = SpriteManager.getInstance();
			ScriptManager.getInstance();
			_enemies = new Array();
			
			_player = new Player();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _player.keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, _player.keyUp);
			
			//add a FPS indicator
			_fpsIndicator = new FPSIndicator(8, 0x00FF00);
			_fpsIndicator.x = 5;
			_fpsIndicator.y = 5;
			//this.addChild(_fpsIndicator);
			
			//add an objects indicator
			_objectsOnScreen = 39; //(counting: 3 indicators, player, 35 background stars)
			_objectsIndicator = new DebugIndicator("Objects", 8, 0x00FF00);
			_objectsIndicator.x = 5;
			_objectsIndicator.y = 25;
			//this.addChild(_objectsIndicator);
			
			//add a collisions indicator
			_collisionsIndicator = new DebugIndicator("Collisions", 8, 0x00FF00);
			_collisionsIndicator.x = 5;
			_collisionsIndicator.y = 45;
			//this.addChild(_collisionsIndicator);
			
			//add the volume controller
			_menuSoundChannel = new SoundChannel();
			_volumeControl = new VolumeControl();
			_volumeControl.x = 370;
			_volumeControl.y = 5;
			this.addChild(_volumeControl);
			_volumeControl.addEventListener(Event.CHANGE, updateVolume);
			
			//load the XML
			var rawData:ByteArray = new ImpossibleCarrotAssets.gameScriptXML;
			var gameScriptXML:XML = new XML( rawData.readUTFBytes( rawData.length ) );
			
			//read in the game events from XML
			_eventScript = new Array();
			for each (var eventSetting:XML in gameScriptXML..Events[0].children())
			{
				var eventObj:Object = new Object();
				if ( eventSetting.name() == "Enemy" )
				{
					eventObj.type = "enemy";
					eventObj.entrance = Number( eventSetting.@entrance );
					eventObj.assetID = eventSetting.@assetID.toString();
					eventObj.motion = eventSetting.@motion.toString();
					eventObj.deployment = eventSetting.@deployment.toString();
					eventObj.layer = int( eventSetting.@layer );
					eventObj.initialX = Number( eventSetting.@initialX );
					eventObj.initialY = Number( eventSetting.@initialY );
					eventObj.direction = Number( eventSetting.@direction );
					if ( eventSetting.@displayRotation.toString() != "" )
					{	eventObj.displayRotation = Boolean(eventSetting.@displayRotation.toString());	}
					else {	eventObj.displayRotation = false;	}
					_eventScript.push(eventObj);
				}
				else if ( eventSetting.name() == "Message" )
				{
					eventObj.type = "message";
				}
			}
			
			//start with the title screen
			showTitleScreen(showScene0);
		}
		
		private function showTitleScreen(onComplete:Function):void
		{
			//create the scene and add the display object
			_menuSoundChannel.stop();
			var sound:Sound = new ImpossibleCarrotAssets.menuMusic();
			var sndTransform:SoundTransform = new SoundTransform();
			sndTransform.volume = _volumeControl.volume;
			_menuSoundChannel = sound.play(0, 9999);
			_menuSoundChannel.soundTransform = sndTransform;
			_activeScene = new TitleScreen();
			_onSceneComplete = onComplete;
			this.addChild(_activeScene);
			this.setChildIndex(_volumeControl, this.numChildren-1);
			
			_activeScene.addEventListener(Event.ENTER_FRAME, checkForComplete, false, 0, true);
		}
		
		private function showSummaryScreen(onComplete:Function):void
		{
			//create the scene and add the display object
			_useVolumeMultiplier = false;
			_volumeMultiplier = 1.0;
			_menuSoundChannel.stop();
			var sound:Sound = new ImpossibleCarrotAssets.endMusic();
			var sndTransform:SoundTransform = new SoundTransform();
			sndTransform.volume = _volumeControl.volume;
			_menuSoundChannel = sound.play(0, 0);
			_menuSoundChannel.soundTransform = sndTransform;
			_activeScene = new SummaryScreen(_collisionCount);
			_onSceneComplete = onComplete;
			this.addChild(_activeScene);
			this.setChildIndex(_volumeControl, this.numChildren-1);
			
			_activeScene.addEventListener(Event.ENTER_FRAME, checkForComplete, false, 0, true);
		}
		
		private function playScene(sceneClass:Class, onComplete:Function):void
		{
			//create the scene and add the display object
			_activeScene = new BasicScene(sceneClass);
			_onSceneComplete = onComplete;
			this.addChild(_activeScene);
			this.setChildIndex(_volumeControl, this.numChildren-1);
			
			_activeScene.addEventListener(Event.ENTER_FRAME, checkForComplete, false, 0, true);
		}
		
		private function checkForComplete(evt:Event = null):void
		{
			//update background display
			_bg.tick();
			_screenBD = new BitmapData(W, H, true, 0x000000);	
			_screenBD.copyPixels(_bg.getBitmapData(), new Rectangle(0, 0, W, H), new Point(0, 0), null, null, true);
			_screenBitmap.bitmapData = _screenBD;
			
			if ( _useVolumeMultiplier && IScene( _activeScene ).getRemainingFrames() < 100 )
			{
				_volumeMultiplier = IScene( _activeScene ).getRemainingFrames() / 100;
				var sndTransform:SoundTransform = new SoundTransform();
				sndTransform.volume = _volumeControl.volume * _volumeMultiplier;
				_menuSoundChannel.soundTransform = sndTransform;
			}
			
			//check end of scene
			if ( IScene(_activeScene).isComplete() )
			{
				onSceneComplete();
			}
		}
		
		private function onSceneComplete(evt:Event = null):void
		{
			_activeScene.removeEventListener(Event.ENTER_FRAME, checkForComplete, false);
			//remove display object
			this.removeChild(_activeScene);
			//perform next function
			_onSceneComplete.call(this);
		}
		
		private function showScene0():void
		{
			if ( !_hasShownScene0 ) //only show scene 0 if it has not been seen before
			{
				_hasShownScene0 = true;
				_useVolumeMultiplier = true;
				_volumeMultiplier = 1.0;
				playScene(ImpossibleCarrotAssets.scene0, showScene1);
			}
			else //otherwise, skip ahead
			{
				showScene1();
			}
		}
		
		private function showScene1():void
		{
			_menuSoundChannel.stop();
			var sound:Sound = new ImpossibleCarrotAssets.introSceneMusic();
			var sndTransform:SoundTransform = new SoundTransform();
			sndTransform.volume = _volumeControl.volume;
			_menuSoundChannel = sound.play(0, 9999);
			_menuSoundChannel.soundTransform = sndTransform;
			_useVolumeMultiplier = true;
			_volumeMultiplier = 1.0;
			playScene(ImpossibleCarrotAssets.scene1, startGame);
		}
		
		private function returnToTitle():void
		{
			showTitleScreen(showScene0);
		}
		
		private function startGame(evt:Event = null):void
		{
			_menuMode = false;
			
			//RESET DATA:
			_collisionCount = 0;
			_recentlyHit = false;
			_timeLastFrame = getTimer();
			_timeLastBeat = getTimer();
			_musicStarted = false;
			_player.resetShipPosition();
			
			//prepare the music file
			if (_musicTracker != null )
			{
				this.removeChild(_musicTracker);
			}
			_musicTracker = new MusicTracker(new ImpossibleCarrotAssets.mainSoundtrack(), [{firstBeatAt:1540, beatsPerMinute:90.2, beatsPerMeasure:4}]);
			this.addChild(_musicTracker);
			
			//start music
			_menuSoundChannel.stop();
			_musicTracker.play();
			_musicTracker.volume = _volumeControl.volume;
			
			//set update listeners
			_musicTracker.addEventListener(MusicTracker.NEW_BEAT, onNewBeat);
			this.addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		private function stopGame(evt:Event = null):void
		{
			//stop music
			_musicTracker.stop();
			
			//clean up listeners
			_musicTracker.removeEventListener(MusicTracker.NEW_BEAT, onNewBeat);
			this.removeEventListener(Event.ENTER_FRAME, mainLoop);
			
			//RESET DATA:
			
			//load the XML
			_menuMode = true;
			var rawData:ByteArray = new ImpossibleCarrotAssets.gameScriptXML;
			var gameScriptXML:XML = new XML( rawData.readUTFBytes( rawData.length ) );
			
			//read in the game events from XML
			_eventScript = new Array();
			for each (var eventSetting:XML in gameScriptXML..Events[0].children())
			{
				var eventObj:Object = new Object();
				if ( eventSetting.name() == "Enemy" )
				{
					eventObj.type = "enemy";
					eventObj.entrance = Number( eventSetting.@entrance );
					eventObj.assetID = eventSetting.@assetID.toString();
					eventObj.motion = eventSetting.@motion.toString();
					eventObj.deployment = eventSetting.@deployment.toString();
					eventObj.layer = int( eventSetting.@layer );
					eventObj.initialX = Number( eventSetting.@initialX );
					eventObj.initialY = Number( eventSetting.@initialY );
					eventObj.direction = Number( eventSetting.@direction );
					if ( eventSetting.@displayRotation.toString() != "" )
					{	eventObj.displayRotation = Boolean(eventSetting.@displayRotation.toString());	}
					else {	eventObj.displayRotation = false;	}
					_eventScript.push(eventObj);
				}
				else if ( eventSetting.name() == "Message" )
				{
					eventObj.type = "message";
				}
			}
		}
		
		private function updateVolume(evt:Event = null):void
		{
			if ( _menuMode )
			{
				var sndTransform:SoundTransform = new SoundTransform();
				sndTransform.volume = _volumeControl.volume;
				_menuSoundChannel.soundTransform = sndTransform;
			}
			else
			{
				_musicTracker.volume = _volumeControl.volume;
			}
		}
		
		private function onNewBeat(evt:Event = null):void
		{
			if ( !_musicStarted )
			{
				_musicStarted = true;
			}
			
			//queue up each event that will happen between this beat and the next
			while ( _eventScript.length > 0 && _musicTracker.cumulativeBeats >= Math.floor(_eventScript[0].entrance)  )
			{
				var eventObj:Object = _eventScript.shift();
			
				if ( eventObj.type == "enemy" )
				{
					if ( eventObj.entrance != Math.floor(eventObj.entrance) )
					{
						_functionQueue.push( {
							timeLeft:( _musicTracker.timePerBeat * Number(eventObj.entrance - Math.floor(eventObj.entrance)) ),
							func:addEnemy,
							args:eventObj
						} );
					}
					else
					{
						addEnemy(eventObj);
					}
				}
				else if ( eventObj.type == "message" )
				{
					//TODO: implement handling of other event types
				}
			}
			
			//increment time
			_timeLastBeat = getTimer();
			
			if ( _musicTracker.cumulativeBeats >= FINAL_BEAT )
			{
				//clean up game and show summary
				stopGame();
				showSummaryScreen(returnToTitle);
			}
		}
		
		private function mainLoop(evt:Event = null):void
		{
			//update displays
			_collisionsIndicator.updateDisplay( String(_collisionCount) );
			_objectsIndicator.updateDisplay( String(_objectsOnScreen) );
			
			//flicker if necessary
			if (_recentlyHit) {
				if (_flickerCountdown == 0) {
					_recentlyHit = false;
					_player.visible = true;
				} else {
					if (_flickerStepCountdown == 0) {
						_flickerStepCountdown = FLICKER_STEP_DURATION;
						_flickerCountdown--;
						_player.visible = !_player.visible;
					} else {
						_flickerStepCountdown--;
					}
				}
			}
			
			//find the time elapsed since last frame (in milliseconds)
			var timeElapsed:uint = getTimer() - _timeLastFrame;
			
			//check function queue
			for (var i:int=0; i<_functionQueue.length; i++)
			{
				//check if the function should be called
				if ( _functionQueue[i].timeLeft <= 0 )
				{
					_functionQueue[i].func.call(this, _functionQueue[i].args);
					_functionQueue.splice(i, 1);
					i--;
					continue;
				}
				
				//decrement the timer
				_functionQueue[i].timeLeft -= timeElapsed;
			}
			
			//increment time
			_timeLastFrame = getTimer();
			
			if ( _musicStarted )
			{
				moveAll(_musicTracker.cumulativeBeats + ((_timeLastFrame-_timeLastBeat)/_musicTracker.timePerBeat));
			}
			else
			{
				moveAll(0);
			}
			updateDisplay();
		}
		
		private function addEnemy(enemyObj:Object):void
		{
			var newEnemy:Enemy = new Enemy( enemyObj );
			//_enemyLayers[enemyObj.layer].addChild(newEnemy);
			_objectsOnScreen++;
			_enemies.unshift(newEnemy);
		}
		
		private function moveAll(currentBeat:Number):void
		{
			//move background
			_bg.tick();
			
			//move enemies
			for (var i:uint = 0; i < _enemies.length; i++)
			{
				//update enemy
				_enemies[i].tick(currentBeat);
				
				//add any pending deployments for this enemy
				while (_enemies[i].pendingDeployments.length > 0)
				{
					addEnemy(_enemies[i].pendingDeployments.shift());
				}
				
				//remove enemy if out of bounds or expired
				if (_enemies[i].isOutOfBounds || _enemies[i].isExpired)
				{
					var layer:uint = _enemies[i].enemyLayer;
					_objectsOnScreen--;
					_enemies.splice(i,1);
					i--;
					continue;
				}
			}
			
			//move player
			_player.tick(currentBeat);
			
			checkCollision();
		}
		
		//checks for collisions
		private function checkCollision():void
		{
			if (!_recentlyHit) {
				for each (var enemy:Enemy in _enemies)
				{
					if (_player.checkCollision(enemy)) { //player just got hit
						_collisionCount++;
						_recentlyHit = true;
						_flickerCountdown = FLICKER_DURATION;
						break;
					}
				}
			}
		}
		
		private function updateDisplay():void
		{
			//clear
			_screenBD = new BitmapData(W, H, true, 0x000000);	
			
			//update background display
			_screenBD.copyPixels(_bg.getBitmapData(), new Rectangle(0, 0, W, H), new Point(0, 0), null, null, true);
			
			//update enemies display
			for (var i:uint = 0; i < _enemies.length; i++)
			{
				var spriteObj:Object = _spriteManager.getEnemySprite(_enemies[i].assetID, _enemies[i].currentFrame);
				
				if ( _enemies[i].displayRotation && Math.abs(_enemies[i].rotation%360) > 10 && Math.abs(_enemies[i].rotation%360) < 350 ) //rotation; requires matrix and draw function
				{
					var mat:Matrix = new Matrix();
					mat.translate(spriteObj.xOffset, spriteObj.yOffset);
					mat.rotate(_enemies[i].rotationInRadians + (Math.PI*2));
					mat.translate(_enemies[i].x, _enemies[i].y);
					_screenBD.draw(spriteObj.bd, mat, null, null, null, true);
				}
				else //no rotation; simply use copyPixels function
				{
					_screenBD.copyPixels(spriteObj.bd, new Rectangle(0, 0, spriteObj.bd.width, spriteObj.bd.height), new Point(_enemies[i].x+spriteObj.xOffset, _enemies[i].y+spriteObj.yOffset), null, null, true);
				}
			}
			
			//update player display
			if ( _player.visible )
			{
				var playerObj:Object = _spriteManager.getPlayerSprite(_player.currentFrame);
				_screenBD.copyPixels(playerObj.bd, new Rectangle(0, 0, playerObj.bd.width, playerObj.bd.height), new Point(_player.shipX+playerObj.xOffset, _player.shipY+playerObj.yOffset), null, null, true);
			}
			
			//refresh
			_screenBitmap.bitmapData = _screenBD;
		}
	}
}