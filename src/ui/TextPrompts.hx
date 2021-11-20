package ui;


import characters.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

using echo.FlxEcho;
using flixel.tweens.FlxTween;

class TextPrompts extends FlxTypedGroup<FlxObject> {
  public function new(player: Player) {
    super();
    // 1 - Running jump test
    final runningJumpTxt = new FlxText(0, FlxG.height - 125, 0, "Run and press [UP] or [SPACE] to jump over things", 48);
    runningJumpTxt.scrollFactor.set(0, 0);
    runningJumpTxt.screenCenter(X);
    runningJumpTxt.alpha = 0;
    add(runningJumpTxt);

    // 2 - Trigger for running jump text
    final runningJumpTextTrigger = new FlxObject(612, 689, 900, 100);
    runningJumpTextTrigger.add_body({mass: 0});
    add(runningJumpTextTrigger);

    // Physics listeners
		player.listen(runningJumpTextTrigger, {
			separate: false,
			enter: (_playerBody, _listenerBody, _) -> runningJumpTxt.tween({alpha: 1}, .3),
			exit: (_playerBody, _listenerBody) -> runningJumpTxt.tween({alpha: 0}, .3),
		});
  }
}