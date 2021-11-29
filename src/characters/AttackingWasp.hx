package characters;

import characters.Player;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;

class AttackingWasp extends FlxTypedGroup<FlxObject> {
  public var sprite: Wasp;
  var playerInSafeZoneOne = false;
  var player: Player;
  var attackListener: FlxObject;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(3);

    this.player = player;
    sprite = new Wasp(x, y);
    add(sprite);

    final safeZoneOne = new FlxObject(20226, 528, 158, 242);
    safeZoneOne.add_body({mass: 0});
    add(safeZoneOne);

    attackListener = new FlxObject((sprite.x - 410), (sprite.y + 300), 252, 108);
    attackListener.add_body({mass: 0});
    add(attackListener);

    // listeners
    safeZoneOne.listen(player, {
      separate: false,
      enter: (_, _, _) -> playerInSafeZoneOne = true,
      exit: (_, _) -> playerInSafeZoneOne = false,
    });

    attackListener.listen(player, {
      separate: false,
      enter: (_, _, _) -> {
        if (sprite.state == Attacking) {
          player.startDeathSequence = true;
        }
      },
    });
  }

  function updateAttackListenerPos(waspSprite: Wasp) {
    final attackListenerBody = attackListener.get_body();
    attackListenerBody.x = waspSprite.x + 100;
    attackListenerBody.y = waspSprite.y + 300;
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    updateAttackListenerPos(sprite);

    if (sprite.alertOne && !playerInSafeZoneOne) {
      sprite.attackPlayer(player);
    }
  }
}