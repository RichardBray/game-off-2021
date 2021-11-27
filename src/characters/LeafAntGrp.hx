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
  var killAntGroupTrigger: FlxObject;
  var memberNum: Int = 0;

  public function new(x: Float = 0, y: Float = 0, player: Player) {
    super(4);

    final antOptions: Array<LeafAntInputs> = [
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

		killAntGroupTrigger = new FlxObject(11248, 589, 167, 216);
		killAntGroupTrigger.add_body({mass: 0});
    add(killAntGroupTrigger);
  }

	override public function update(elapsed: Float) {
		super.update(elapsed);
    this.forEach((member: FlxObject) -> {
      memberNum++;
      if (memberNum != 4) {
        var antOverlap = FlxG.overlap(member, killAntGroupTrigger);
        if (antOverlap) {
          member.kill();
        }
      }
    });
	}
}