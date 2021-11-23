package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;
import utils.Colors;

abstract class GameState extends FlxState {

	var version = "";

	override public function create() {
		super.create();
		bgColor = Colors.groundGreen;
		FlxAssets.FONT_DEFAULT = "assets/fonts/Rokkitt-Regular.ttf";

		FlxG.autoPause = false;
		FlxG.camera.antialiasing = true;
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);
	}
}