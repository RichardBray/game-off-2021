package levels;

import characters.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import states.LevelState;
import utils.Colors;

using echo.FlxEcho;
using hxmath.math.Vector2;
final class LevelTwo extends LevelState {
  var player: Player;
  var ground: FlxSprite;
  var box: FlxSprite;

	override function create() {
		super.create();

		FlxEcho.init({
			width: FlxG.width,
			height: FlxG.height,
			gravity_y: 700
		});

		player = new Player(0, 0);
		add(player);

		ground = new FlxSprite(
			0,
			FlxG.height - 160
		).makeGraphic(FlxG.width, 160, 0xFF000000);
		ground.add_body({mass: 0});
		add(ground);

		box = new FlxSprite(
			200,
			0
		).makeGraphic(30, 30, 0xFF000000);

    box.add_body({
      mass: 1,
      elasticity: 0.5,
      drag_length: 300,
    });
    add(box);

		player.listen(ground);
		box.listen(player);
		box.listen(ground);

		FlxG.log.add("LevelTwo.create()");
		FlxG.log.notice("LevelTwo.create two()");
	}
}