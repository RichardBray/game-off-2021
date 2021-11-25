package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;
import utils.Colors;

abstract class GameState extends FlxState {

	override public function create() {
		super.create();
		this.bgColor = Colors.skyGreen;
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