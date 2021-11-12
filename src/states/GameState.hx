package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import utils.Colors;
import utils.LoadFile;

abstract class GameState extends FlxState {
	final pjson = LoadFile.json("./package.json");

	var version = "";

	override public function create() {
		super.create();
		bgColor = Colors.grey;
		version = pjson.version;

		FlxAssets.FONT_DEFAULT = "assets/fonts/OpenSans-Regular.ttf";
		// add(new FlxText('Hello World $version', 32).screenCenter());

		FlxG.autoPause = false;
		FlxG.camera.antialiasing = true;
		FlxG.mouse.useSystemCursor = true;

		#if !debug
		FlxG.mouse.visible = false;
		#end
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);
	}
}