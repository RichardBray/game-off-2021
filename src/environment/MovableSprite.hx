package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Colors;

using echo.FlxEcho;

class MovableSprite extends FlxTypedGroup<FlxObject> {
  var sprite: FlxSprite;
  var pushingTrigger: FlxObject;
  var player: Player;
  public function new(x: Float, y: Float, player: Player) {
    super(2);

    this.player = player;
    // 1 - pushing state trigger
    pushingTrigger = new FlxObject((x - 60), y, 70, 88);
    pushingTrigger.add_body({mass: 0});
    this.add(pushingTrigger);

    // 2 - sprite
    sprite = new FlxSprite(x, y);
    sprite.makeGraphic(43, 88, Colors.grey);
    sprite.add_body({mass: 0});
    this.add(sprite);

    player.listen(sprite);

		player.listen(pushingTrigger, {
			separate: false,
			enter: (_, _, _) ->  player.inPushableTrigger = true,
			exit: (_, _) ->  player.inPushableTrigger = false,
		});
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    var spriteBody = sprite.get_body();
    var triggerBody = pushingTrigger.get_body();

    if (player.state == Pushing) {
      spriteBody.mass = 5;
      spriteBody.drag_length = 700;
    }

    if (player.state != Pushing) {
      triggerBody.x = (spriteBody.x - 60);
      spriteBody.mass = 0;
    }
  }
}