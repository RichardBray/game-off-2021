package levels;

import characters.Player;
import characters.PlayerClimb;
import environment.Hole;
import environment.Pebbles;
import environment.SmlMushroom;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import openfl.filters.ShaderFilter;
import shaders.Pixelate;
import states.GameState;
import ui.TextPrompts;
import utils.Colors;
import utils.GameDataStore;

using echo.FlxEcho;
using hxmath.math.Vector2;
final class LevelTwo extends GameState {
	final dataStore = GameDataStore.instance;
	var player: Player;
	var groundListener: FlxObject;

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
		final BG_SPRITE_WIDTH = 2357;
		final BG_SPRITE_HEIGHT = 1885;
		final totalBackgroundSprites = Math.ceil(fullMapWidth / BG_SPRITE_WIDTH);
		final grpBackground = new FlxTypedGroup<FlxSprite>(totalBackgroundSprites);

		for (backgroundSprite in 0...totalBackgroundSprites) {
			final xPos = BG_SPRITE_WIDTH * backgroundSprite;
			final background = new FlxSprite(xPos, -641);
			background.loadGraphic(
				"assets/images/environment/grassTile.png",
				BG_SPRITE_WIDTH, BG_SPRITE_HEIGHT
			);
			background.alpha = 0.65;
			grpBackground.add(background);
		}

		// - midground sprite
		final GROUND_HEIGHT_FROM_BASE = 244;
		groundListener = new FlxObject(
			0,
			FlxG.height - GROUND_HEIGHT_FROM_BASE,
			FlxG.width * 2,
			GROUND_HEIGHT_FROM_BASE
		);
		groundListener.add_body({mass: 0});

		//  - player sprites
		final playerClimb = new PlayerClimb();
		player = new Player(93, 793, playerClimb);

		// - environments objects
		final smlMushroom = new SmlMushroom(2500, 610, player);
		final pebbles = new Pebbles(player);
		final hole = new Hole(1747, 828, player);
		final holeCovering = new FlxSprite((hole.x - 16), (FlxG.height - GROUND_HEIGHT_FROM_BASE));
		holeCovering.makeGraphic(101, GROUND_HEIGHT_FROM_BASE, Colors.groundGreen);

		// - help text
		// final textPropmpts = new TextPrompts(player);

		// - order objects
		this.add(grpBackground);
		this.add(groundListener);
		this.add(smlMushroom);
		this.add(pebbles);
		this.add(hole);
		this.add(playerClimb);
		this.add(player);
		this.add(holeCovering);
		// add(textPropmpts);

		// - physics listeners
		player.listen(groundListener);

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

	override function update(elapsed: Float) {
		super.update(elapsed);

		groundListener.get_body().active = dataStore.data.enableGroundListener;

		if (player.get_body().y > FlxG.height) {
			dataStore.setDefaults();
			FlxG.resetState();
		}
	}
}
