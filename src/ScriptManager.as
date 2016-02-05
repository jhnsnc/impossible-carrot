package
{
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class ScriptManager
	{
		private static var _instance:ScriptManager;
		
		private var _motionScripts:Object;
		private var _deploymentScripts:Object;
		
		public function ScriptManager(singleton:SingletonEnforcer)
		{
			if(!singleton) throw new Error("You cannot instantiate the ScriptManager class using the constructor. Please use ScriptManager.getInstance() instead.");
			initialize();
		}
		
		static public function getInstance():ScriptManager
		{
			if(!_instance)
			{
				_instance = new ScriptManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function initialize(evt:Event = null):void
		{
			//load the XML
			var rawData:ByteArray = new ImpossibleCarrotAssets.gameScriptXML;
			var gameScriptXML:XML = new XML( rawData.readUTFBytes( rawData.length ) );
			
			//read in the motion scripts from XML
			_motionScripts = new Object();
			for each (var motionXML:XML in gameScriptXML..MotionScripts[0].children())
			{
				if ( motionXML.name() == "MotionScript" )
				{
					_motionScripts[motionXML.@id.toString()] = new MotionScript(motionXML.@id.toString());
				}
			}
			
			//read in the deployment scripts from XML
			_deploymentScripts = new Object();
			for each (var deploymentXML:XML in gameScriptXML..DeploymentScripts[0].children())
			{
				if ( deploymentXML.name() == "DeploymentScript" )
				{
					_deploymentScripts[deploymentXML.@id.toString()] = new DeploymentScript(deploymentXML.@id.toString());
				}
			}
		}
		
		public function getMotionScript(id:String):MotionScript
		{
			return _motionScripts[id];
		}
		
		public function getDeploymentScript(id:String):DeploymentScript
		{
			return _deploymentScripts[id];
		}
	}
}

class SingletonEnforcer
{
	public function SingletonEnforcer(){};
}