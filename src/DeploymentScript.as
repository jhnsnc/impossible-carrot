package
{
	import flash.utils.ByteArray;

	public class DeploymentScript
	{
		private var _repeatDeployments:Array;
		private var _staticDeployments:Array;
		
		public function DeploymentScript(scriptID:String)
		{
			//load the XML
			var rawData:ByteArray = new ImpossibleCarrotAssets.gameScriptXML;
			var gameScriptXML:XML = new XML( rawData.readUTFBytes( rawData.length ) );
			
			//find the XML for the script with the appropriate ID
			var scriptXML:XML;
			for each (scriptXML in gameScriptXML..DeploymentScripts[0].DeploymentScript)
			{
				if (scriptXML.@id.toString() == scriptID)
				{
					break;
				}
			}
			
			//read in the deployment script
			_repeatDeployments = new Array();
			_staticDeployments = new Array();
			for each (var deploymentSettings:XML in scriptXML..Deployment)
			{
				var enemyObj:Object = new Object();
				enemyObj.assetID = deploymentSettings.@assetID.toString();
				enemyObj.entrance = Number(deploymentSettings.@entrance); //all timings begin at 0 as far as the deployment script is concerned
				enemyObj.motion = deploymentSettings.@motion.toString();
				enemyObj.deployment = deploymentSettings.@deployment.toString();
				enemyObj.initialX = Number(deploymentSettings.@initialX);
				enemyObj.initialY = Number(deploymentSettings.@initialY);
				enemyObj.direction = Number(deploymentSettings.@direction);
				if ( deploymentSettings.@displayRotation.toString() != "" )
				{	enemyObj.displayRotation = Boolean(deploymentSettings.@displayRotation.toString());	}
				else {	enemyObj.displayRotation = false;	}
				enemyObj.repeat = Number(deploymentSettings.@repeat.toString());
				
				if ( deploymentSettings.@repeatTurn.toString() != "" )
				{	enemyObj.repeatTurn = Number(deploymentSettings.@repeatTurn.toString());	}
				else {	enemyObj.repeatTurn = 0;	}
				
				if ( deploymentSettings.@repeatLimit.toString() != "" )
				{	enemyObj.repeatLimit = int(deploymentSettings.@repeatLimit.toString());	}
				else {	enemyObj.repeatLimit = -1;	}
				
				//add to either the static deployments array or the repeat deployments array
				if (enemyObj.repeat > 0)
				{
					_repeatDeployments.push(enemyObj);
				}
				else
				{
					_staticDeployments.push(enemyObj);
				}
			}
		}
		
		//get all new deployments between time1 and time2; all timings begin at 0 as far as the deployment script is concerned
		public function getNewDeployments(time1:Number, time2:Number):Array
		{
			var i:uint;
			var obj:Object;
			var deployments:Array = new Array();
			
			//search static deployments
			for (i = 0; i < _staticDeployments.length; i++)
			{
				if ( _staticDeployments[i].entrance > time1 && _staticDeployments[i].entrance <= time2 ) 
				{
					obj = new Object();
					obj.assetID = _staticDeployments[i].assetID;
					obj.entrance = _staticDeployments[i].entrance;
					obj.motion = _staticDeployments[i].motion;
					obj.deployment = _staticDeployments[i].deployment;
					obj.initialX = _staticDeployments[i].initialX;
					obj.initialY = _staticDeployments[i].initialY;
					obj.direction = _staticDeployments[i].direction;
					obj.displayRotation = _staticDeployments[i].displayRotation;
					deployments.push(obj);
				}
			}
			
			//insert dynamic deployments
			for (i = 0; i < _repeatDeployments.length; i++)
			{
				var relTime1:Number = time1 - _repeatDeployments[i].entrance; //used to determine the repeatNum; will count up until it exceeds relTime2
				var relTime2:Number = time2 - _repeatDeployments[i].entrance;
				var repeatNum:uint = (relTime1 > 0) ? ( Math.ceil(relTime1/_repeatDeployments[i].repeat)) : 0;
				
				while ( (_repeatDeployments[i].repeat * repeatNum) <= relTime2 && relTime1 < relTime2 && relTime2 >= 0 )
				{
					if ( repeatNum <= _repeatDeployments[i].repeatLimit || _repeatDeployments[i].repeatLimit == -1 ) //make sure this is not past the repeat limit
					{
						//hard clone object to push back
						obj = new Object();
						obj.assetID = _repeatDeployments[i].assetID;
						obj.entrance = _repeatDeployments[i].entrance + (_repeatDeployments[i].repeat * repeatNum);
						obj.motion = _repeatDeployments[i].motion;
						obj.deployment = _repeatDeployments[i].deployment;
						obj.initialX = _repeatDeployments[i].initialX;
						obj.initialY = _repeatDeployments[i].initialY;
						obj.direction = _repeatDeployments[i].direction + (_repeatDeployments[i].repeatTurn * repeatNum);
						obj.displayRotation = _repeatDeployments[i].displayRotation;
						deployments.push(obj);
						
						if (relTime1 < 0) {	relTime1 %= _repeatDeployments[i].repeat;	}
						relTime1 += _repeatDeployments[i].repeat;
						repeatNum = (relTime1 > 0) ? ( Math.ceil(relTime1/_repeatDeployments[i].repeat)) : 0;
					}
					else //past repeat limit, so no need to check while loop again
					{
						break;
					}
				}
			}
			
			return deployments;
		}
	}
}