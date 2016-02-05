package
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	public class Player
	{
		private const NORM_SPEED:Number = 120;
		private const SLOW_SPEED:Number = 60;
		private const COLLISION_SIZE:Number = 2; //half the width of the (imaginary) collision box for the player's ship 
		
		private var _lastTickTime:Number;
		private var _lastTickBeat:Number;
		private var _movementsSinceLastTick:Array;
		
		private var _direction:int;
		private var _speed:Number;
		private var _keysPressed:Array; //up, down, left, right, shift
		
		private var _x:Number;
		private var _y:Number;
		private var _currentFrame:uint;
		
		public var visible:Boolean;
		
		public function Player()
		{
			//initialize variables
			_lastTickTime = 0.0;
			_lastTickBeat = 0.0;
			_movementsSinceLastTick = new Array;
			_direction = Direction.NONE;
			_speed = NORM_SPEED;
			_keysPressed = [false, false, false, false, false];
			
			visible = true;
			
			//build
			build();
		}
		
		private function build():void
		{
			resetShipPosition();
			_currentFrame = 3; //"center"
		}
		
		public function keyDown(evt:KeyboardEvent):void
		{
			//update which keys are pressed
			if (evt.keyCode == Keyboard.UP) {
				_keysPressed[0] = true;
			} else if (evt.keyCode == Keyboard.DOWN) {
				_keysPressed[1] = true;
			} else if (evt.keyCode == Keyboard.LEFT) {
				_keysPressed[2] = true;
			} else if (evt.keyCode == Keyboard.RIGHT) {
				_keysPressed[3] = true;
			} else if (evt.keyCode == Keyboard.SHIFT) {
				_keysPressed[4] = true;
			}
			
			updateDirectionAndSpeed();
		}
		
		public function keyUp(evt:KeyboardEvent):void
		{
			//update which keys are pressed
			if (evt.keyCode == Keyboard.UP) {
				_keysPressed[0] = false;
			} else if (evt.keyCode == Keyboard.DOWN) {
				_keysPressed[1] = false;
			} else if (evt.keyCode == Keyboard.LEFT) {
				_keysPressed[2] = false;
			} else if (evt.keyCode == Keyboard.RIGHT) {
				_keysPressed[3] = false;
			} else if (evt.keyCode == Keyboard.SHIFT) {
				_keysPressed[4] = false;
			}
			
			updateDirectionAndSpeed();
		}
		
		private function updateDirectionAndSpeed():void
		{
			//movement is changing; add this last movement to queue before changing direction/speed 
			var movementObj:Object = new Object();
			movementObj.time = getTimer();
			movementObj.direction = _direction;
			movementObj.speed = _speed;
			_movementsSinceLastTick.push(movementObj);
			
			//update direction
			if (_keysPressed[2] && !_keysPressed[3]) { //west
				if (_keysPressed[0] && !_keysPressed[1]) { //north
					_direction = Direction.NORTHWEST;
				} else if (_keysPressed[1] && !_keysPressed[0]) { //south
					_direction = Direction.SOUTHWEST;
				} else { //no vertical movement
					_direction = Direction.WEST;
				}
				//_ship.gotoAndStop(_keysPressed[4] ? "left" : "left-hard");
				_currentFrame = (_keysPressed[4] ? 2 : 1); //? "left" : "left-hard"
			} else if (_keysPressed[3] && !_keysPressed[2]) { //east
				if (_keysPressed[0] && !_keysPressed[1]) { //north
					_direction = Direction.NORTHEAST;
				} else if (_keysPressed[1] && !_keysPressed[0]) { //south
					_direction = Direction.SOUTHEAST;
				} else { //no vertical movement
					_direction = Direction.EAST;
				}
				//_ship.gotoAndStop(_keysPressed[4] ? "right" : "right-hard");
				_currentFrame = (_keysPressed[4] ? 4 : 5); //? "right" : "right-hard"
			} else { //no horizontal movement
				if (_keysPressed[0] && !_keysPressed[1]) { //north
					_direction = Direction.NORTH;
				} else if (_keysPressed[1] && !_keysPressed[0]) { //south
					_direction = Direction.SOUTH;
				} else { //no vertical movement
					_direction = Direction.NONE;
				}
				//_ship.gotoAndStop("center");
				_currentFrame = 3; //"center"
			}
			
			//update speed
			_speed = (_keysPressed[4]) ? SLOW_SPEED : NORM_SPEED;
		}
		
		public function tick(currentBeat:Number):void
		{
			var currentTime:Number = getTimer();
			var timeSinceLastTick:Number = currentTime - _lastTickTime;
			var beatsSinceLastTick:Number = currentBeat - _lastTickBeat;
			
			//update movements with current movement in progress
			_movementsSinceLastTick.push({time:currentTime, direction:_direction, speed:_speed});
			
			//process each movement
			for (var i:uint = 0; i < _movementsSinceLastTick.length; i++)
			{
				var numBeats:Number; //the calculated number of beats to apply to this movement
				if ( i == 0 ) //no previous movement; use time last tick
				{
					numBeats = beatsSinceLastTick * ((_movementsSinceLastTick[i].time - _lastTickTime) / timeSinceLastTick);
				}
				else
				{
					numBeats = beatsSinceLastTick * ((_movementsSinceLastTick[i].time - _movementsSinceLastTick[i-1].time) / timeSinceLastTick);
				}
				
				if (_direction != Direction.NONE) {
					_x += numBeats * _speed * Math.cos(_direction / 4 * Math.PI);
					_y -= 0.75 * numBeats * _speed * Math.sin(_direction / 4 * Math.PI);
				}
				
				if (_x < 10) { _x = 10; } //out of bounds left
				if (_x > Main.W - 10) { _x = Main.W - 10; } //out of bounds right
				if (_y < 15) { _y = 15; } //out of bounds top
				if (_y > Main.H - 15) { _y = Main.H - 15; } //out of bounds bottom
			}
			
			_movementsSinceLastTick = new Array();
			_lastTickTime = currentTime;
			_lastTickBeat = currentBeat;
		}
		
		public function checkCollision(enemy:Enemy):Boolean
		{
			/*
			var collisionObj:Object = enemy.getCollisionObject();
			var diff:Point = collisionObj.point.subtract(new Point(_x, _y)); //the difference of displacement between the player and this enemy
			var collisionDistance:Number = COLLISION_SIZE + collisionObj.radius; //the maximum difference of displacement for a collision to occur; any closer and a collision has occured
			if ( diff.x > collisionDistance || -diff.x > collisionDistance || diff.y > collisionDistance || -diff.y > collisionDistance ) //cull before performing circular collision check
			{
				return false;
			}
			else
			{
				if ( (diff.x * diff.x) + (diff.y * diff.y) <= (collisionDistance * collisionDistance) ) //displacement is less than or equal to collision displacement; collision has occured
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			*/
			/*
			var enemyBox:Rectangle = enemy.getCollisionBox();
			if (enemyBox.right >= _x - COLLISION_SIZE && enemyBox.left <= _x + COLLISION_SIZE) { //possible collision by horizontal position
				if (enemyBox.bottom >= _y - COLLISION_SIZE && enemyBox.top <= _y + COLLISION_SIZE) { //confirmed collision by vertical position
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
			*/
			var collisionDist:Number = COLLISION_SIZE + enemy.collisionRadius;
			var diffX:Number = Math.abs( _x - enemy.x );
			if ( diffX <= collisionDist ) { //possible collision by horizontal position
				var diffY:Number = Math.abs( _y - enemy.y );
				if (  diffY <= collisionDist ) { //confirmed collision by vertical position
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
		
		public function resetShipPosition():void
		{
			_x = Main.W * 0.5;
			_y = Main.H * 0.7;
		}
		
		public function get shipX():Number {	return _x;	}
		public function get shipY():Number {	return _y;	}
		public function get currentFrame():uint {	return _currentFrame;	}
	}
}