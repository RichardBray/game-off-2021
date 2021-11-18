package levels;

import characters.Player;
import characters.PlayerClimb;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import openfl.filters.ShaderFilter;
import shaders.Pixelate;
import states.GameState;
import utils.Colors;

using echo.FlxEcho;
using hxmath.math.Vector2;
final class LevelTwo extends GameState {

	override function create() {
		super.create();
		final fullMapWidth = FlxG.width * 2;
		// - physics world
		FlxEcho.init({
			width: fullMapWidth,
			height: FlxG.height,
			gravity_y: 960,
		});
		// - background sprites
		final BG_SPRITE_WIDTH = 1351;
		final totalBackgroundSprites = Math.ceil(fullMapWidth / BG_SPRITE_WIDTH);
		final grpBackground = new FlxTypedGroup<FlxSprite>(totalBackgroundSprites);

		for (backgroundSprite in 0...totalBackgroundSprites) {
			final xPos = BG_SPRITE_WIDTH * backgroundSprite;
			final background = new FlxSprite(xPos, 0).loadGraphic("assets/images/environment/grassTile.png", false, BG_SPRITE_WIDTH, FlxG.height);
			grpBackground.add(background);
		}

		add(grpBackground);

		// - midground sprite
		final GROUND_HEIGHT_FROM_BASE = 244;
		final ground = new FlxObject(
			0,
			FlxG.height - GROUND_HEIGHT_FROM_BASE,
			FlxG.width * 2,
			GROUND_HEIGHT_FROM_BASE
		);
		ground.add_body({mass: 0});
		add(ground);

		// - environments objects
		final ledge = new FlxSprite(601, 618).makeGraphic(
			250,
			5,
			Colors.grey
		);
		ledge.add_body({mass: 0});
		add(ledge);

		final ledgeListener = new FlxObject(585, 707, 280, 90);
		ledgeListener.add_body({mass: 0});
		add(ledgeListener);

		//  - player sprites
		final playerClimb = new PlayerClimb();
		add(playerClimb);

		final player = new Player(93, 793, playerClimb);
		add(player);

		// - physics listeners
		player.listen(ground);
		player.listen(ledge);

		FlxEcho.listen(ledgeListener, player, {
			separate: false,
			enter: (ledgeListenerBody, playerBody, _) -> player.allowClimb = true,
			exit: (ledgeListenerBody, playerBody) -> player.allowClimb = false,
		});

		// - camera settings
		FlxG.worldBounds.set(0, 0, FlxG.width * 2, FlxG.height);
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.width * 2, FlxG.height);
		FlxG.camera.follow(player);
		FlxG.camera.deadzone = FlxRect.get(
			((FlxG.camera.width - (player.width)) / 2) - 300,
			((FlxG.camera.height - player.height) / 2),
			player.width,
			player.height
		);

		if (false) { // TODO add pixelation menu option
			var effect = new Pixelate();
			FlxG.camera.setFilters([new ShaderFilter(cast effect)]);
		}
	}
}
