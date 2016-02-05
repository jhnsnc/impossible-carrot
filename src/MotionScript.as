package
{
	import flash.utils.ByteArray;
	
	import ndef.parser.Parser;

	public class MotionScript
	{
		private var _parser:Parser;
		
		private var _paths:Array; //{duration(in beats), direction(polar theta(0-2*PI)), forwardEq, sidewaysEq}
		private var _pathDisplacements:Array; //{direction, x, y}
		
		public function MotionScript(scriptID:String)
		{
			//load the XML
			var rawData:ByteArray = new ImpossibleCarrotAssets.gameScriptXML;
			var gameScriptXML:XML = new XML( rawData.readUTFBytes( rawData.length ) );
			
			//find the XML for the script with the appropriate ID
			var scriptXML:XML;
			for each (scriptXML in gameScriptXML..MotionScripts[0].MotionScript)
			{
				if (scriptXML.@id.toString() == scriptID)
				{
					break;
				}
			}
			
			//read in the script paths
			_paths = new Array();
			for each (var pathSettings:XML in scriptXML..Path)
			{
				_paths.push( {
					duration: Number( pathSettings.@duration ),
					direction: pathSettings.@direction.toString(),
					x: pathSettings.@x.toString(),
					y: pathSettings.@y.toString()
				} );
			}
			
			//parse and simplify each path segment
			_parser = new Parser(["t", "playerX", "playerY"]);
			var i:uint;
			for (i = 0; i < _paths.length; i++)
			{
				_paths[i].parsedDirection = _parser.simplify( _parser.parse( _paths[i].direction ) );
				_paths[i].parsedX = _parser.simplify( _parser.parse( _paths[i].x ) );
				_paths[i].parsedY = _parser.simplify( _parser.parse( _paths[i].y ) );
			}
			
			//calculate ending path displacements
			_pathDisplacements = new Array();
			for (i = 0; i < _paths.length; i++)
			{
				var displacementObj:Object = new Object();
				displacementObj.x = _parser.eval(_paths[i].parsedX, [_paths[i].duration, 0, 0]);
				displacementObj.y = _parser.eval(_paths[i].parsedY, [_paths[i].duration, 0, 0]);
				displacementObj.direction = _parser.eval(_paths[i].parsedDirection, [_paths[i].duration, 0, 0]);
				_pathDisplacements.push(displacementObj);
			}
		}
		
		public function getDisplacement(time:Number):Object
		{
			var displacementObj:Object = new Object();
			displacementObj.x = 0.0;
			displacementObj.y = 0.0;
			displacementObj.direction = 0.0;
			for (var i:uint = 0; i < _paths.length; i++)
			{
				if ( time > _paths[i].duration ) //this path segment already completed
				{
					time -= _paths[i].duration;
					displacementObj.x += _pathDisplacements[i].x;
					displacementObj.y += _pathDisplacements[i].y;
					displacementObj.direction += _pathDisplacements[i].direction;
				}
				else
				{
					displacementObj.x += _parser.eval(_paths[i].parsedX, [time, 0, 0]);
					displacementObj.y += _parser.eval(_paths[i].parsedY, [time, 0, 0]);
					displacementObj.direction += _parser.eval(_paths[i].parsedDirection, [time, 0, 0]);
					break;
				}
			}
			return displacementObj;
		}
		
		public function recalculatePathDisplacement(pathIdx:uint):void
		{
			var displacementObj:Object = new Object();
			displacementObj.x = _parser.eval(_paths[pathIdx].parsedX, [_paths[pathIdx].duration, 0, 0]);
			displacementObj.y = _parser.eval(_paths[pathIdx].parsedY, [_paths[pathIdx].duration, 0, 0]);
			displacementObj.direction = _parser.eval(_paths[pathIdx].parsedDirection, [_paths[pathIdx].duration, 0, 0]);
			_pathDisplacements[pathIdx] = displacementObj;
		}
		
		public function getTotalScriptDuration():Number
		{
			var totalDuration:Number = 0;
			for (var i:uint = 0; i < _paths.length; i++)
			{
				totalDuration += _paths[i].duration;
			}
			return totalDuration;
		}
	}
}