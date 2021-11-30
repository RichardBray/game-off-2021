package substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

import states.StartScreens;

import utils.Colors;
import utils.Controls;

class LevelComplete extends FlxSubState {
  final controls = Controls.instance;

  override public function create() {
    super.create();
    this.bgColor = Colors.black;

    final title = new FlxText(0, 200, 0, "Thanks for playing", 120);
		title.screenCenter(X);
		title.scrollFactor.set(0, 0);
		add(title);

    final subText = new FlxText(0, 400, 0, "Press [SPACE] to go to start again", 60);
		subText.screenCenter(X);
		subText.scrollFactor.set(0, 0);
		add(subText);

    final subText = new FlxText(0, 600, 0, "Press [P] from the main menu to go pixel mode", 40);
		subText.screenCenter(X);
		subText.scrollFactor.set(0, 0);
		add(subText);
  }

  override public function update(elapsed:Float) {
    if(controls.cross.check()) {
      FlxG.switchState(new StartScreens());
      close();
    }
    super.update(elapsed);

  }
}