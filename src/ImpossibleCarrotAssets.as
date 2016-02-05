package
{
	public class ImpossibleCarrotAssets
	{
		[Embed(source="assets/gameScript.xml", mimeType="application/octet-stream")]
		public static const gameScriptXML:Class;
		
		[Embed(source="assets/mainMusic.mp3")]
		public static const mainSoundtrack:Class;
		
		[Embed(source="assets/buySell.mp3")]
		public static const menuMusic:Class;
		
		[Embed(source="assets/tyrianSong.mp3")]
		public static const introSceneMusic:Class;
		
		[Embed(source="assets/endOfLevel.mp3")]
		public static const endMusic:Class;
		
		[Embed(source="assets/scenes.swf", symbol='titleScreen')]
		public static const titleScreen:Class;
		
		[Embed(source="assets/scenes.swf", symbol='summaryScreen')]
		public static const summaryScreen:Class;
		
		[Embed(source="assets/scenes.swf", symbol='scene0')]
		public static const scene0:Class;
		
		[Embed(source="assets/scenes.swf", symbol='scene1')]
		public static const scene1:Class;
		
		[Embed(source="assets/assets.swf", symbol='volumeControlButton')]
		public static const volumeControlButton:Class;
		
		[Embed(source="assets/assets.swf", symbol='player')]
		public static const playerSprite:Class;
		public static const playerInfo:Object = {xOffset:-12, yOffset:-14};
		
		[Embed(source="assets/assets.swf", symbol='starTwinkle')]
		public static const starTwinkle:Class;
		
		[Embed(source="assets/assets.swf", symbol='starStaticS')]
		public static const starStaticS:Class;
		
		[Embed(source="assets/assets.swf", symbol='starStaticL')]
		public static const starStaticL:Class;
		
		public static const starClasses:Array = [ //don't change order of this array (hard-coded in [default package].SpriteManager.as (function getStarSprite()))
			{asset:starTwinkle, chance:0.15, singleFrame:false, keyframes:[1,43,49,55,61,67]},
			{asset:starStaticS, chance:0.50, singleFrame:true},
			{asset:starStaticL, chance:0.35, singleFrame:true}
		];
		
		[Embed(source="assets/assets.swf", symbol='willowisp')]
		public static const enemyWillowisp:Class;
		
		[Embed(source="assets/assets.swf", symbol='vortex')]
		public static const enemyVortex:Class;
		
		[Embed(source="assets/assets.swf", symbol='tornado')]
		public static const enemyTornado:Class;
		
		[Embed(source="assets/assets.swf", symbol='juggler')]
		public static const enemyJuggler:Class;
		
		[Embed(source="assets/assets.swf", symbol='jugglerPiece')]
		public static const enemyJugglerPiece:Class;
		
		[Embed(source="assets/assets.swf", symbol='thorn')]
		public static const enemyThorn:Class;
		
		[Embed(source="assets/assets.swf", symbol='spike')]
		public static const enemySpike:Class;
		
		[Embed(source="assets/assets.swf", symbol='glob')]
		public static const enemyGlob:Class;
		
		[Embed(source="assets/assets.swf", symbol='bombA')]
		public static const enemyBombA:Class;
		
		[Embed(source="assets/assets.swf", symbol='bombB')]
		public static const enemyBombB:Class;
		
		[Embed(source="assets/assets.swf", symbol='blackbird')]
		public static const enemyBlackbird:Class;
		
		[Embed(source="assets/assets.swf", symbol='sparrow')]
		public static const enemySparrow:Class;
		
		[Embed(source="assets/assets.swf", symbol='catalyst')]
		public static const enemyCatalyst:Class;
		
		[Embed(source="assets/assets.swf", symbol='phoenix')]
		public static const enemyPhoenix:Class;
		
		[Embed(source="assets/assets.swf", symbol='redStar1')]
		public static const bulletRedStar1:Class;
		
		[Embed(source="assets/assets.swf", symbol='redStar2')]
		public static const bulletRedStar2:Class;
		
		[Embed(source="assets/assets.swf", symbol='redStar3')]
		public static const bulletRedStar3:Class;
		
		[Embed(source="assets/assets.swf", symbol='redStar4')]
		public static const bulletRedStar4:Class;
		
		[Embed(source="assets/assets.swf", symbol='blueBubble1')]
		public static const bulletBlueBubble1:Class;
		
		[Embed(source="assets/assets.swf", symbol='blueBubble2')]
		public static const bulletBlueBubble2:Class;
		
		[Embed(source="assets/assets.swf", symbol='blueBubble3')]
		public static const bulletBlueBubble3:Class;
		
		[Embed(source="assets/assets.swf", symbol='blueBubble4')]
		public static const bulletBlueBubble4:Class;
		
		[Embed(source="assets/assets.swf", symbol='whiteBubble1')]
		public static const bulletWhiteBubble1:Class;
		
		[Embed(source="assets/assets.swf", symbol='whiteBubble2')]
		public static const bulletWhiteBubble2:Class;
		
		[Embed(source="assets/assets.swf", symbol='whiteBubble3')]
		public static const bulletWhiteBubble3:Class;
		
		[Embed(source="assets/assets.swf", symbol='whiteBubble4')]
		public static const bulletWhiteBubble4:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballD')]
		public static const bulletFireballD:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballDDL')]
		public static const bulletFireballDDL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballDL')]
		public static const bulletFireballDL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballDLL')]
		public static const bulletFireballDLL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballL')]
		public static const bulletFireballL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballULL')]
		public static const bulletFireballULL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballUL')]
		public static const bulletFireballUL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballUUL')]
		public static const bulletFireballUUL:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballU')]
		public static const bulletFireballU:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballUUR')]
		public static const bulletFireballUUR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballUR')]
		public static const bulletFireballUR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballURR')]
		public static const bulletFireballURR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballR')]
		public static const bulletFireballR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballDRR')]
		public static const bulletFireballDRR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballDR')]
		public static const bulletFireballDR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireballDDR')]
		public static const bulletFireballDDR:Class;
		
		[Embed(source="assets/assets.swf", symbol='fireBomb')]
		public static const bulletFireBomb:Class;
		
		[Embed(source="assets/assets.swf", symbol='missile')]
		public static const bulletMissile:Class;
		
		[Embed(source="assets/assets.swf", symbol='redLaser')]
		public static const bulletRedLaser:Class;
		
		[Embed(source="assets/assets.swf", symbol='blueLaser')]
		public static const bulletBlueLaser:Class;
		
		public static const enemyClasses:Array = [
			{id:"willowisp",	asset:enemyWillowisp,		collisionRadius:1,	singleFrame:false, keyframes:[1,5,9,13,17], xOffset:-4.5, yOffset:-8.5},
			{id:"vortex",		asset:enemyVortex,			collisionRadius:9,	singleFrame:false, keyframes:[1,4,7,10,13,16,19,22], xOffset:-10.5, yOffset:-10.5},
			{id:"tornado",		asset:enemyTornado,			collisionRadius:5,	singleFrame:false, keyframes:[1,4,7,10,13,16,19,22], xOffset:-7.5, yOffset:-9.0},
			{id:"juggler",		asset:enemyJuggler,			collisionRadius:9,	singleFrame:false, keyframes:[1,5,9,13], xOffset:-10.5, yOffset:-12.5},
			{id:"jugglerPiece",	asset:enemyJugglerPiece,	collisionRadius:2,	singleFrame:true, xOffset:-4.5, yOffset:-4.5},
			{id:"thorn",		asset:enemyThorn,			collisionRadius:2,	singleFrame:false, keyframes:[1,4,7,10,13,16], xOffset:-5.5, yOffset:-5.0},
			{id:"spike",		asset:enemySpike,			collisionRadius:4,	singleFrame:false, keyframes:[1,4,7,10], xOffset:-8.5, yOffset:-11.0},
			{id:"glob",			asset:enemyGlob,			collisionRadius:4,	singleFrame:false, keyframes:[1,8,13,16], xOffset:-6.0, yOffset:-22.0},
			{id:"bombA",		asset:enemyBombA,			collisionRadius:3.5,singleFrame:false, keyframes:[1,8,13,16], xOffset:-5.5, yOffset:-5.5},
			{id:"bombB",		asset:enemyBombB,			collisionRadius:3.5,singleFrame:false, keyframes:[1,8,13,16], xOffset:-5.5, yOffset:-5.5},
			{id:"blackbird",	asset:enemyBlackbird,		collisionRadius:6,	singleFrame:true, xOffset:-12.0, yOffset:-8.0},
			{id:"sparrow",		asset:enemySparrow,			collisionRadius:6,	singleFrame:true, xOffset:-12.0, yOffset:-11.0},
			{id:"catalyst",		asset:enemyCatalyst,		collisionRadius:10,	singleFrame:true, xOffset:-24.0, yOffset:-10.0},
			{id:"phoenix",		asset:enemyPhoenix,			collisionRadius:6,	singleFrame:false, keyframes:[1,46,51,71], xOffset:-9.5, yOffset:-15.0},
			{id:"redStar1",		asset:bulletRedStar1,		collisionRadius:1,	singleFrame:false, keyframes:[1,5], xOffset:-5.5, yOffset:-5.5},
			{id:"redStar2",		asset:bulletRedStar2,		collisionRadius:1,	singleFrame:false, keyframes:[1,5], xOffset:-5.5, yOffset:-5.5},
			{id:"redStar3",		asset:bulletRedStar3,		collisionRadius:1.5,singleFrame:false, keyframes:[1,5], xOffset:-5.5, yOffset:-5.5},
			{id:"redStar4",		asset:bulletRedStar4,		collisionRadius:2,	singleFrame:false, keyframes:[1,5], xOffset:-6.5, yOffset:-6.5},
			{id:"blueBubble1",	asset:bulletBlueBubble1,	collisionRadius:1,	singleFrame:true, xOffset:-2.5, yOffset:-2.5},
			{id:"blueBubble2",	asset:bulletBlueBubble2,	collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-2.5},
			{id:"blueBubble3",	asset:bulletBlueBubble3,	collisionRadius:2,	singleFrame:true, xOffset:-3.5, yOffset:-3.5},
			{id:"blueBubble4",	asset:bulletBlueBubble4,	collisionRadius:3,	singleFrame:true, xOffset:-5.5, yOffset:-5.5},
			{id:"whiteBubble1",	asset:bulletWhiteBubble1,	collisionRadius:1,	singleFrame:true, xOffset:-2.0, yOffset:-2.0},
			{id:"whiteBubble2",	asset:bulletWhiteBubble2,	collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-2.5},
			{id:"whiteBubble3",	asset:bulletWhiteBubble3,	collisionRadius:2,	singleFrame:true, xOffset:-3.5, yOffset:-3.5},
			{id:"whiteBubble4",	asset:bulletWhiteBubble4,	collisionRadius:3,	singleFrame:true, xOffset:-5.5, yOffset:-5.5},
			{id:"fireballD",	asset:bulletFireballD,		collisionRadius:1.5,singleFrame:true, xOffset:-2.0, yOffset:-9.0},
			{id:"fireballDDL",	asset:bulletFireballDDL,	collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-8.5},
			{id:"fireballDL",	asset:bulletFireballDL,		collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-8.5},
			{id:"fireballDLL",	asset:bulletFireballDLL,	collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-4.0},
			{id:"fireballL",	asset:bulletFireballL,		collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-2.0},
			{id:"fireballULL",	asset:bulletFireballULL,	collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-2.0},
			{id:"fireballUL",	asset:bulletFireballUL,		collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-2.5},
			{id:"fireballUUL",	asset:bulletFireballUUL,	collisionRadius:1.5,singleFrame:true, xOffset:-2.5, yOffset:-2.5},
			{id:"fireballU",	asset:bulletFireballU,		collisionRadius:1.5,singleFrame:true, xOffset:-2.0, yOffset:-2.0},
			{id:"fireballUUR",	asset:bulletFireballUUR,	collisionRadius:1.5,singleFrame:true, xOffset:-3.5, yOffset:-2.5},
			{id:"fireballUR",	asset:bulletFireballUR,		collisionRadius:1.5,singleFrame:true, xOffset:-8.5, yOffset:-2.5},
			{id:"fireballURR",	asset:bulletFireballURR,	collisionRadius:1.5,singleFrame:true, xOffset:-8.5, yOffset:-2.5},
			{id:"fireballR",	asset:bulletFireballR,		collisionRadius:1.5,singleFrame:true, xOffset:-8.5, yOffset:-2.0},
			{id:"fireballDRR",	asset:bulletFireballDRR,	collisionRadius:1.5,singleFrame:true, xOffset:-8.5, yOffset:-4.0},
			{id:"fireballDR",	asset:bulletFireballDR,		collisionRadius:1.5,singleFrame:true, xOffset:-8.5, yOffset:-8.5},
			{id:"fireballDDR",	asset:bulletFireballDDR,	collisionRadius:1.5,singleFrame:true, xOffset:-3.5, yOffset:-8.5},
			{id:"fireBomb",		asset:bulletFireBomb,		collisionRadius:3,	singleFrame:false, keyframes:[1,4,7,10,13], xOffset:-5, yOffset:-9},
			{id:"missile",		asset:bulletMissile,		collisionRadius:1.5,singleFrame:true, xOffset:-3.5, yOffset:-9.0},
			{id:"redLaser",		asset:bulletRedLaser,		collisionRadius:1,	singleFrame:true, xOffset:-1.5, yOffset:-9.0},
			{id:"blueLaser",	asset:bulletBlueLaser,		collisionRadius:1,	singleFrame:true, xOffset:-1.5, yOffset:-9.0}
		];
		
		public function ImpossibleCarrotAssets()
		{
		}
	}
}