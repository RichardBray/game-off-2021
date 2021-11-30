package substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

import levels.LevelTwo;

import utils.Controls;

class MainMenu extends FlxSubState {
  final controls = Controls.instance;

  public function new() {
    super();
  }
  override public function create() {
    super.create();

    final title = new FlxText(0, 200, 0, "A Little Scared", 120);
		title.screenCenter(X);
		title.scrollFactor.set(0, 0);
		add(title);

    final subText = new FlxText(0, 400, 0, "Press [SPACE] to start", 60);
		subText.screenCenter(X);
		subText.scrollFactor.set(0, 0);
		add(subText);
  }

  override public function update(elapsed:Float) {
    if (controls.cross.check()) {
      FlxG.switchState(new LevelTwo(false));
      close();
    }
    if (FlxG.keys.pressed.P) {
      FlxG.switchState(new LevelTwo(false, true));
      close();
    }
    super.update(elapsed);

  }
}