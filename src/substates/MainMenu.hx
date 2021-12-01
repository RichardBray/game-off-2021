package substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

import levels.LevelTwo;

import utils.Controls;
import utils.GameDataStore;

class MainMenu extends FlxSubState {
  final controls = Controls.instance;
  final dataStore = GameDataStore.instance;

  override public function create() {
    super.create();
    bgColor = 0x75000000;

    final title = new FlxText(0, 200, 0, "A Little Scared", 140);
		title.screenCenter(X);
		title.scrollFactor.set(0, 0);
		add(title);

    final title = new FlxText(0, 340, 0, "Github game off 2021 entry", 40);
		title.screenCenter(X);
		title.scrollFactor.set(0, 0);
		add(title);

    final subText = new FlxText(0, 500, 0, "Press [SPACE] to start", 60);
		subText.screenCenter(X);
		subText.scrollFactor.set(0, 0);
		add(subText);
  }

  override public function update(elapsed:Float) {
    if (controls.cross.check()) {
      dataStore.data.pixelMode = false;
      FlxG.switchState(new LevelTwo(false));
      close();
    }
    if (FlxG.keys.pressed.P) {
      dataStore.data.pixelMode = true;
      FlxG.switchState(new LevelTwo(false));
      close();
    }
    super.update(elapsed);

  }
}