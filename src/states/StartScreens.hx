package states;

import flixel.FlxG;
import flixel.FlxSprite;

import levels.LevelTwo;

import utils.Colors;

using flixel.tweens.FlxTween;

class StartScreens extends GameState {

  var seconds: Float = 0;
  var hlScreen: FlxSprite;
  var ghScreen: FlxSprite;

	override public function create() {
		super.create();
    this.bgColor = Colors.white;

    FlxG.cameras.fade(bgColor, 0.5, true);

    hlScreen = new FlxSprite(0, 0);
    hlScreen.loadGraphic("assets/images/ui/HL_Screens.png", 1920, 1080);
    add(hlScreen);

    ghScreen = new FlxSprite(0, 0);
    ghScreen.loadGraphic("assets/images/ui/GO_Screen.png", 1920, 1080);
    ghScreen.alpha = 0;
    add(ghScreen);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
    seconds += elapsed;
    if (seconds > 2 && seconds < 3) {
      hlScreen.tween({alpha: 0}, 0.5);
    }
    if (seconds > 3 && seconds < 4) {
      ghScreen.tween({alpha: 1}, 0.5);
    }
    if (seconds > 6 && seconds < 7) {
      ghScreen.tween({alpha: 0}, 0.5);
    }
    if (seconds > 8) {
      FlxG.switchState(new LevelTwo(true));
    }
  }
}
