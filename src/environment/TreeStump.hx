package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;
using utils.SpriteHelpers;

class TreeStump extends FlxTypedGroup<FlxObject> {
  var player: Player;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(7);
    this.player = player;
    // 1 - main sprite
    final mainSprite = new FlxSprite(x, y);
    // mainSprite.makeGraphic(1591, 671, Colors.grey);
    mainSprite.loadGraphic("assets/images/environment/TreeTrunk_01.png", 2048, 843);
		mainSprite.changeHitboxSize({
			reduceWidthBy: 784,
			reduceHeightBy: 59,
			heightOffset: 35,
			widthOffset: -20,
		});
    mainSprite.add_body({mass: 0});
    add(mainSprite);

    // 2 - low climb
    final lowClimb = new FlxObject(x - 120, y + 455, 120, 14);
    lowClimb.add_body({mass: 0});
    add(lowClimb);

    // 3 - low climb listener
    final lowClimbListener = new FlxObject(x - 112, y + 564, 107, 114);
    lowClimbListener.add_body({mass: 0});
    addCliemableListener(lowClimbListener);
    add(lowClimbListener);

    // 4 - mid climb
    final midClimb = new FlxObject(x - 120, y + 231, 120, 14);
    midClimb.add_body({mass: 0});
    add(midClimb);

    // 5 - mid climb listener
    final midClimbListener = new FlxObject(x - 112, y + 341, 107, 114);
    midClimbListener.add_body({mass: 0});
    addCliemableListener(midClimbListener);
    add(midClimbListener);

    // 6 - high climb
    final highClimb = new FlxObject(x - 120, y, 120, 14);
    highClimb.add_body({mass: 0});
    add(highClimb);

    // 7 - high climb listener
    final highClimbListener = new FlxObject(x - 112, y + 117, 107, 114);
    highClimbListener.add_body({mass: 0});
    addCliemableListener(highClimbListener);
    add(highClimbListener);

    // listeners
    mainSprite.listen(player);
    lowClimb.listen(player);
    midClimb.listen(player);
    highClimb.listen(player);
  }

  function addCliemableListener(object: FlxObject) {
		player.listen(object, {
			separate: false,
			enter: (_, _, _) -> player.allowClimb = true,
			exit: (_, _) -> player.allowClimb = false,
		});
  }
}