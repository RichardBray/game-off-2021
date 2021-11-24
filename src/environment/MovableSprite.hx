package environment;

import characters.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;
using utils.SpriteHelpers;

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

    // 1 - sprite
    sprite = new FlxSprite(x, (y + 7));
    sprite.loadFrames("environment/items");
		sprite.animation.frameName = "Rock_01.png";
    sprite.width = 64;
    sprite.height = 100;
    sprite.offset.set(-20, 40);
    sprite.add_body({mass: 0});
    add(sprite);

    // 2 - space buffer
    spaceBuffer = new FlxObject((x - 35),sprite.y, 35, sprite.height);
    spaceBuffer.add_body({mass: 0});
    add(spaceBuffer);

    // 3 - pushing state trigger
    pushingTrigger = new FlxObject(0, sprite.y, 10, sprite.height);
    pushingTrigger.add_body({mass: 0});
    add(pushingTrigger);

    player.listen(sprite);
    player.listen(spaceBuffer);
    sprite.listen(spaceBuffer);

		player.listen(pushingTrigger, {
			separate: false,
			enter: (_, _, _) ->  {
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
      triggerBody.x = (spaceBufferBody.x - 20);
      spriteBody.mass = 0;
      spaceBufferBody.mass = 0;
    }
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    updatePushableSpritePhysics();
  }
}