package characters;

import characters.LeafAnt.LeafAntInputs;
import characters.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.typeLimit.OneOfTwo;

using echo.FlxEcho;

class LeafAntGrp extends FlxTypedGroup<OneOfTwo<LeafAnt, FlxObject>> {
  final SPACING = 600;
  var movementStarted = false;
  var killAntGroupTrigger: FlxObject;
  var overlappedAnts: Int = 0;
  var antOptions: Array<LeafAntInputs>;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(5);

    antOptions = [
      {
        x: x,
        y: y,
        spriteSheet: "characters/leafAnt2",
        framePrefix: "LeafAnt_v2-",
        collisionWidth: 453,
        collisionXOffset: 260,
        collisionYOffset: 20,
      },
      {
        x: x + SPACING,
        y: y,
        spriteSheet: "characters/leafAnt3",
        framePrefix: "LeafAnt_v3-",
        collisionWidth: 593,
        collisionXOffset: 320,
        collisionYOffset: 10,
      },
      {
        x: x + (SPACING * 2),
        y: y,
        spriteSheet: "characters/leafAnt1",
        framePrefix: "LeafAnt_v1-",
        collisionWidth: 253,
        collisionXOffset: 210,
        collisionYOffset: 100,
      },
    ];

    for (antOption in antOptions) {
      final antSprite = new LeafAnt(antOption);
      antSprite.collisionListener.listen(player);
      add(antSprite);
    }

		killAntGroupTrigger = new FlxObject(13474, 589, 167, 216);
    add(killAntGroupTrigger);

		final shiftAntGroupsTrigger = new FlxObject(15815, 241, 49, 106);
		shiftAntGroupsTrigger.add_body({mass: 0});
    add(shiftAntGroupsTrigger);

    shiftAntGroupsTrigger.listen(player, {
      separate: false,
      enter: (_, _, _) -> {
        disableCollisions();
      }
    });
  }

  public function startMovement() {
    if (movementStarted) {
      return;
    }
    for (i in 0...3) {
      final ant: LeafAnt = this.members[i];
      ant.startMovement();
    }
    movementStarted = true;
  }

  function resetAntsOnTrigger() {
    for (i in 0...3) {
      final ant: LeafAnt = this.members[i];
      final antOverlap = FlxG.overlap(ant, killAntGroupTrigger);
      if (antOverlap) {
        overlappedAnts++;
        ant.kill();
      }
      if (overlappedAnts == 3) {
        resetAnts();
        overlappedAnts = 0;
      }
    }
  }

  function resetAnts() {
    for (i in 0...3) {
      final ant: LeafAnt = this.members[i];
      ant.revive();
      ant.resetPosition();
    }
  }

  function disableCollisions() {
    for (i in 0...3) {
      final ant: LeafAnt = this.members[i];
      ant.disableCollision();
    }
  }

	override public function update(elapsed: Float) {
    resetAntsOnTrigger();
		super.update(elapsed);
	}
}