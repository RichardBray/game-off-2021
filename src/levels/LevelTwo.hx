package levels;

import characters.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import openfl.filters.ShaderFilter;
import shaders.Pixelate;
import states.LevelState;

using echo.FlxEcho;
using hxmath.math.Vector2;
final class LevelTwo extends LevelState {
  var player: Player;
  var ground: FlxSprite;
  var box: FlxSprite;

	override function create() {
		super.create();

		FlxEcho.init({
			width: FlxG.width * 2,
			height: FlxG.height,
			gravity_y: 700,
		});

		ground = new FlxSprite(
			0,
			FlxG.height - 160
		).makeGraphic(FlxG.width * 2, 160, 0xFF000000);
		ground.add_body({mass: 0});
		add(ground);

		player = new Player(0, 0);
		add(player);

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

		// var effect = new Pixelate();
		// FlxG.camera.setFilters([new ShaderFilter(cast effect)]);

		FlxG.worldBounds.set(0, 0, FlxG.width * 2, FlxG.height);
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.width * 2, FlxG.height);
		FlxG.camera.follow(player);
		FlxG.camera.deadzone = FlxRect.get(
			((FlxG.camera.width - (player.width)) / 2) - 300,
			((FlxG.camera.height - player.height) / 2),
			player.width,
			player.height
		);
	}
}
