package characters;

import characters.Player;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

using echo.FlxEcho;

class AttackingWasp extends FlxTypedGroup<FlxObject> {
  public var sprite: Wasp;
  var playerInSafeZoneOne = false;
  var playerInSafeZoneTwo = false;
  var playerInSafeZoneThree = false;
  var player: Player;
  var attackListener: FlxObject;
  var playerDeathSet = false;

  var attackPositionSet = false;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(3);

    this.player = player;

    // 1 - wasp sprite
    sprite = new Wasp(x, y);
    add(sprite);

    // 2 - player safe zone one
    final safeZoneOne = new FlxObject(20205, 528, 179, 242);
    safeZoneOne.add_body({mass: 0});
    add(safeZoneOne);

    // 3 - player safe zone two
    final safeZoneTwo = new FlxObject(20024, 665, 92, 170);
    safeZoneTwo.add_body({mass: 0});
    add(safeZoneTwo);

    // 4 - player safe zone three
    final safeZoneThree = new FlxObject(20195, 665, 89, 170);
    safeZoneThree.add_body({mass: 0});
    add(safeZoneThree);

    // 5 - attack object on wasp
    attackListener = new FlxObject(sprite.x, sprite.y, 252, 108);
    attackListener.add_body({mass: 0});
    add(attackListener);

    // listeners
    safeZoneOne.listen(player, {
      separate: false,
      enter: (_, _, _) -> playerInSafeZoneOne = true,
      exit: (_, _) -> playerInSafeZoneOne = false,
    });

    safeZoneTwo.listen(player, {
      separate: false,
      enter: (_, _, _) -> playerInSafeZoneTwo = true,
      exit: (_, _) -> playerInSafeZoneTwo = false,
    });

    safeZoneThree.listen(player, {
      separate: false,
      enter: (_, _, _) -> playerInSafeZoneThree = true,
      exit: (_, _) -> playerInSafeZoneThree = false,
    });

    attackListener.listen(player, {
      separate: false,
      enter: (_, _, _) -> playerDeathSet = true,
    });
  }

  function updateAttackListenerPos(waspSprite: Wasp) {
    final attackListenerBody = attackListener.get_body();
    if (waspSprite.facing == FlxObject.RIGHT) {
      attackListenerBody.x = waspSprite.x + 420;
    } else {
      attackListenerBody.x = waspSprite.x + 180;
    }
    attackListenerBody.y = waspSprite.y + 300;
  }

  function startPlayerDeath() {
    if (playerDeathSet && sprite.state == Attacking) {
      trace('this should hit 2');
      player.startDeathSequence = true;
      playerDeathSet = false;
    }
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
    updateAttackListenerPos(sprite);
    startPlayerDeath();

    if (sprite.alertOne && !playerInSafeZoneOne && !playerInSafeZoneTwo) {
      sprite.attackPlayer(player);
    }

    if (sprite.alertTwo && !playerInSafeZoneThree && !playerInSafeZoneTwo) {
      sprite.attackPlayer(player, FlxObject.RIGHT);
    }
  }
}