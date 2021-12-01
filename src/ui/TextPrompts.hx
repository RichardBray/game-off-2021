package ui;


import characters.Player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

using echo.FlxEcho;

using flixel.tweens.FlxTween;

class TextPrompts extends FlxTypedGroup<FlxObject> {
  final allHelpText: Array<String> = [
    "Press directional arrows or [A] [D] to move left or right",
    "Run and press [UP] or [SPACE] to jump over things",
    "Press [SHIFT] to interact with objects",
    "Stand still and jump to climb",
    "Stand under mushrooms to hide from flying enemies",
  ];

  final helpTextTriggerPos: Array<Array<Int>> = [
    [256, 689],
    [1612, 689],
    [3248, 689],
  ];

  public function new(player: Player) {
    super(allHelpText.length + helpTextTriggerPos.length);
    // 1 - Add all text
    for (helpText in allHelpText) {
      final helpTextSprite = new FlxText(0, FlxG.height - 125, 0, helpText, 48);
      helpTextSprite.scrollFactor.set(0, 0);
      helpTextSprite.screenCenter(X);
      helpTextSprite.alpha = 0;
      add(helpTextSprite);
    }

    // 2 - All text triggers
    for (triggerPos in helpTextTriggerPos) {
      final testTrigger = new FlxObject(triggerPos[0], triggerPos[1], 900, 100);
      testTrigger.add_body({mass: 0});
      add(testTrigger);
  }

    // Physics listeners
    for (i in 0...helpTextTriggerPos.length) {
      player.listen(this.members[i + 5], {
        separate: false,
        enter: (_playerBody, _listenerBody, _) -> this.members[i].tween({alpha: 1}, .3),
        exit: (_playerBody, _listenerBody) -> this.members[i].tween({alpha: 0}, .3),
      });
    }
  }
}