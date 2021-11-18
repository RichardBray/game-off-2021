package levels;

import characters.Player;
import characters.PlayerClimb;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import openfl.filters.ShaderFilter;
import shaders.Pixelate;
import states.LevelState;
import utils.Colors;

using echo.FlxEcho;
using hxmath.math.Vector2;
final class LevelTwo extends LevelState {
  var player: Player;

	override function create() {
		super.create();
		// - physics world
		FlxEcho.init({
			width: FlxG.width * 2,
			height: FlxG.height,
			gravity_y: 960,
		});

		final ground = new FlxSprite(
			0,
			FlxG.height - 160
		).makeGraphic(FlxG.width * 2, 160, Colors.purple);
		ground.add_body({mass: 0});
		add(ground);

		final ledge = new FlxSprite(601, 702).makeGraphic(
			250,
			5,
			Colors.lilac
		);
		ledge.add_body({mass: 0});
		add(ledge);

		final ledgeListener = new FlxObject(585, 707, 280, 90);
		ledgeListener.add_body({mass: 0});
		add(ledgeListener);

		final playerClimb = new PlayerClimb();
		add(playerClimb);

		player = new Player(93, 793, playerClimb);
		add(player);

		player.listen(ground);
		player.listen(ledge);

		FlxEcho.listen(ledgeListener, player, {
			separate: false,
			enter: (ledgeListenerBody, playerBody, _) -> player.allowClimb = true,
			exit: (ledgeListenerBody, playerBody) -> player.allowClimb = false,
		});

		if (false) { // TODO add pixelation menu option
			var effect = new Pixelate();
			FlxG.camera.setFilters([new ShaderFilter(cast effect)]);
		}

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
