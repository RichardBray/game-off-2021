package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Colors;

using echo.FlxEcho;


class TreeStump extends FlxTypedGroup<FlxObject> {
  var player: Player;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(4);
    this.player = player;
    // 1 - main sprite
    final mainSprite = new FlxSprite(x, y);
    mainSprite.makeGraphic(1591, 678, Colors.grey);
    mainSprite.add_body({mass: 0});
    add(mainSprite);

    // 2 - low climb
    final lowClimb = new FlxObject(0, 0, 120, 14);
    lowClimb.add_body({mass: 0});
    addCliemableListener(lowClimb);
    add(lowClimb);

    // 3 - mid climb
    final midClimb = new FlxObject(0, 0, 80, 14);
    midClimb.add_body({mass: 0});
    addCliemableListener(midClimb);
    add(midClimb);

    // 4 - high climb
    final highClimb = new FlxObject(0, 0, 60, 14);
    highClimb.add_body({mass: 0});
    addCliemableListener(highClimb);
    add(highClimb);

    // listeners
    mainSprite.listen(player);
  }

  function addCliemableListener(object: FlxObject) {
		player.listen(object, {
			separate: false,
			enter: (_, _, _) -> player.allowClimb = true,
			exit: (_, _) -> player.allowClimb = false,
		});
  }
}