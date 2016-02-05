package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//BasicEnemy moves straight ahead at a static speed each tick
	public class Enemy
	{
		private var _constructorObj:Object;
		private var _scriptManager:ScriptManager;
		
		private var _entranceBeat:Number;
		private var _lastTick:Number;
		private var _currentFrame:uint;
		private var _totalFrames:uint;
		
		private var _collisionRadius:Number;
		private var _motionDuration:Number;
		
		public var pendingDeployments:Array;
		
		private var _x:Number;
		private var _y:Number;
		private var _rotation:Number;
		
		public var _isExpired:Boolean;
		public var _hasEnteredScreen:Boolean;
		public var _isOutOfBounds:Boolean;
		
		public function Enemy(enemyObj:Object)
		{
			super();
			_constructorObj = enemyObj;
			
			_scriptManager = ScriptManager.getInstance();
			
			//set starting point data
			_entranceBeat = _constructorObj.entrance;
			_lastTick = 0.0;
			_currentFrame = 1;
			_totalFrames = SpriteManager.getInstance().getEnemyTotalFrames(_constructorObj.assetID);
			_hasEnteredScreen = false;
			
			//create this enemy asset
			_collisionRadius = SpriteManager.getInstance().getEnemyCollisionRadius(_constructorObj.assetID);
			//_collisionRadius = ImpossibleCarrotAssets.enemyClasses[idx]["collisionRadius"];
			_constructorObj.radians = _constructorObj.direction * Math.PI / 180;
			_motionDuration = _scriptManager.getMotionScript(_constructorObj.motion).getTotalScriptDuration();
			pendingDeployments = new Array();
			
			tick(_entranceBeat); //set initial position
		}
		
		public function tick(currentBeat:Number):void
		{
			//check for new deployments
			var newDeployments:Array = _scriptManager.getDeploymentScript(_constructorObj.deployment).getNewDeployments(_lastTick, currentBeat-_entranceBeat); //between last tick and this one
			
			//update time
			_lastTick = currentBeat - _entranceBeat;
			
			
			//update location and rotation
			var displacementObj:Object = _scriptManager.getMotionScript(_constructorObj.motion).getDisplacement(_lastTick);
			var rotatedDisplacement:Point = applyRotation(displacementObj.x, displacementObj.y, _constructorObj.radians);
			_x = _constructorObj.initialX + rotatedDisplacement.x;
			_y = _constructorObj.initialY + rotatedDisplacement.y;
			_rotation = _constructorObj.direction + displacementObj.direction;
			
			//deploy new enemies after making adjustments to the entrance, layer, initialX, initialY, and direction properties
			while (newDeployments.length > 0)
			{
				newDeployments[0].layer = (_constructorObj.layer>0) ? _constructorObj.layer-1 : 0;
				var rotatedOffsets:Point = applyRotation( newDeployments[0].initialX, newDeployments[0].initialY, _rotation*Math.PI/180 );
				var dispAtDeploymentTime:Object = _scriptManager.getMotionScript(_constructorObj.motion).getDisplacement(newDeployments[0].entrance); //get the accurate x, y, and direction for this enemy at the new deployment's entrance time
				var rotatedDeploymentTimeDisplacement:Point = applyRotation( dispAtDeploymentTime.x, dispAtDeploymentTime.y, _constructorObj.radians);
				newDeployments[0].initialX = rotatedOffsets.x + _constructorObj.initialX + rotatedDeploymentTimeDisplacement.x;
				newDeployments[0].initialY = rotatedOffsets.y + _constructorObj.initialY + rotatedDeploymentTimeDisplacement.y;
				newDeployments[0].direction += _constructorObj.direction + dispAtDeploymentTime.direction;
				newDeployments[0].entrance += _entranceBeat;
				pendingDeployments.push(newDeployments.shift());
			}
			
			//update flags
			_isOutOfBounds = (_y < -10 || _y > Main.H + 10 || _x < -10 || _x > Main.W + 10);
			if ( !_hasEnteredScreen )  //does not count as being out of bounds if it has not yet entered the screen area
			{
				_hasEnteredScreen = !_isOutOfBounds;
				_isOutOfBounds = false;
			}
			_isExpired = (_lastTick >= _motionDuration);
		}
		
		private function applyRotation(x:Number, y:Number, rad:Number):Point
		{
			var newPt:Point = new Point();
			newPt.x = x*Math.cos(rad) + y*-1*Math.sin(rad);
			newPt.y = x*Math.sin(rad) + y*Math.cos(rad);
			return newPt;
		}
		
		public function get isOutOfBounds():Boolean { return _isOutOfBounds; }
		public function get isExpired():Boolean { return _isExpired; }
		
		public function getCollisionObject():Object
		{
			return {point:new Point(_x, _y), radius:_collisionRadius};
		}
		
		public function getCollisionBox():Rectangle
		{
			return new Rectangle(_x-_collisionRadius, _y-_collisionRadius, _collisionRadius*2, _collisionRadius*2);
		}
		
		public function get enemyLayer():uint {	return _constructorObj.layer;	}
		public function get assetID():String {	return _constructorObj.assetID;	}
		public function get displayRotation():Boolean {	return _constructorObj.displayRotation;	}
		
		public function get x():Number {	return _x;	}
		public function get y():Number {	return _y;	}
		public function get rotation():Number {	return _rotation;	}
		public function get rotationInRadians():Number {	return _rotation * Math.PI / 180;	}
		public function get collisionRadius():Number {	return _collisionRadius;	}
		public function get currentFrame():uint
		{
			_currentFrame++;
			if (_currentFrame > _totalFrames)
			{
				_currentFrame = 1;
			}
			return _currentFrame;
		}
	}
}