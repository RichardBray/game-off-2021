package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;
import utils.Colors;

abstract class GameState extends FlxState {

	var version = "";

	override public function create() {
		super.create();
		bgColor = Colors.lilac;
		FlxAssets.FONT_DEFAULT = "assets/fonts/OpenSans-Regular.ttf";

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