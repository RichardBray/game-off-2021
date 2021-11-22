package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Colors;

using echo.FlxEcho;

class MovableSprite extends FlxTypedGroup<FlxObject> {
  static inline final OBJECT_DRAG = 400;
  static inline final OBJECT_MASS = 3;
  var sprite: FlxSprite;
  var pushingTrigger: FlxObject;
  var spaceBuffer: FlxObject;
  var player: Player;

  public function new(x: Float, y: Float, player: Player) {
    super(3);

    this.player = player;
    // 1 - pushing state trigger
    pushingTrigger = new FlxObject((x - 45), y, 10, 88);
    pushingTrigger.add_body({mass: 0});
    add(pushingTrigger);

    // 2 - sprite
    sprite = new FlxSprite(x, y);
    sprite.makeGraphic(43, 88, Colors.grey);
    sprite.add_body({mass: 0});
    add(sprite);

    // 3 - space buffer
    spaceBuffer = new FlxObject((x - 35), y, 35, 88);
    spaceBuffer.add_body({mass: 0});
    add(spaceBuffer);

    player.listen(sprite);
    player.listen(spaceBuffer);
    sprite.listen(spaceBuffer);

		player.listen(pushingTrigger, {
			separate: false,
			enter: (playerBody, _, _) ->  {
        player.inPushableTrigger = true;
      },
			exit: (_, _) ->  player.inPushableTrigger = false,
		});
  }

  function updatePushableSpritePhysics() {
    var spriteBody = sprite.get_body();
    var spaceBufferBody = spaceBuffer.get_body();
    var triggerBody = pushingTrigger.get_body();

    if (player.state == Pushing) {
      spriteBody.mass = OBJECT_MASS;
      spriteBody.drag_length = OBJECT_DRAG;
      spaceBufferBody.mass = OBJECT_MASS;
      spaceBufferBody.drag_length = OBJECT_DRAG;
    }

    if (player.state != Pushing) {
      triggerBody.x = (spriteBody.x - 60);
      spriteBody.mass = 0;
      spaceBufferBody.mass = 0;
    }
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    updatePushableSpritePhysics();
  }
}