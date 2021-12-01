package substates;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;

class PauseMenu extends FlxSubState {
	var bgOverlay: FlxSprite;
	var title: FlxText;

	override public function create() {
		super.create();
		bgColor = 0x75000000;
		if (FlxG.sound.music != null) {
			FlxG.sound.music.pause();
		}
		FlxG.sound.pause();

		final title = new FlxText(0, 100, 0, "Game paused", 120);
		title.screenCenter(X);
		title.scrollFactor.set(0, 0);
		add(title);
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) {
			if (FlxG.sound.music != null) {
				FlxG.sound.music.play();
			}
			FlxG.sound.resume();
			close();
		}
	}
}