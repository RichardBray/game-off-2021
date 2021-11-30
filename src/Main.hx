package;

import flixel.FlxGame;

import openfl.display.Sprite;

import states.StartScreens;
class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(1920, 1080, StartScreens, true));
		// addChild(new FlxGame(1920, 1080, states.LevelTwo, true));
	}
}