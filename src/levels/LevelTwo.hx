package levels;

import characters.Ant;
import characters.AttackingWasp;
import characters.LeafAntGrp;
import characters.Player;
import characters.PlayerClimb;
import characters.Spider;
import characters.Wasp;

import environment.CoverGrass;
import environment.Hole;
import environment.MovableSprite;
import environment.Mushrooms;
import environment.Pebbles;
import environment.PlantStem;
import environment.TreeStump;
import environment.TreeStumpCover;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;

import openfl.filters.ShaderFilter;

import shaders.Pixelate;

import states.GameState;

import substates.LevelComplete;
import substates.MainMenu;

import ui.TextPrompts;

import utils.Checkpoints;
import utils.Colors;
import utils.GameDataStore;

using echo.FlxEcho;

using flixel.tweens.FlxTween;

using hxmath.math.Vector2;

final class LevelTwo extends GameState {
	final dataStore = GameDataStore.instance;
	var player: Player;
	var groundListener: FlxObject;
	var waspFlyByTrigger: FlxObject;
	var antReturnTrigger: FlxObject;
	var spiderMovementTrigger: FlxObject;
	var antTrigger: FlxObject;
	var wasp: Wasp;
	var cameraUpTrigger: FlxObject;
	var cameraDownTrigger: FlxObject;
	var endOfLevelSet = false;
	var mainMenuSet = false;
	var pixelationSet = false;

	// - triggers set
	var cameraUpSet: Bool = false;
	var cameraDownSet: Bool = false;

	public function new(showMainMenu: Bool = false, pixelation: Bool = false) {
		super();
		mainMenuSet = showMainMenu;
		pixelationSet = pixelation;
	}
	override function create() {
		super.create();
		final fullMapWidth = FlxG.width * 12;

		// - physics world
		FlxEcho.init({
			width: fullMapWidth,
			height: FlxG.height,
			gravity_y: 960,
		});
		// - background sprites
		final BG_SPRITE_WIDTH = 2353;
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
			grpBackground.add(background);
		}

		// - midground sprite
		final GROUND_HEIGHT_FROM_BASE = 244;
		groundListener = new FlxObject(
			0,
			FlxG.height - GROUND_HEIGHT_FROM_BASE,
			fullMapWidth,
			GROUND_HEIGHT_FROM_BASE
		);
		groundListener.add_body({mass: 0});

		// - player sprites
		final playerClimb = new PlayerClimb();
		player = new Player(dataStore.data.playerPos.x, dataStore.data.playerPos.y, playerClimb);
		player.alpha = 0;
		// - npc sprites
		final ant = new Ant(4789, 685, player);
		final patrollingAnt = new Ant(14372, 685, player);
		wasp = new Wasp(6760, 0);
		wasp.alpha = 0;
		final waspTwo = new AttackingWasp(20707, -300, player);
		waspTwo.sprite.state = Hovering;
		final spider = new Spider(11292, -450, player);
		final leafAntGroup = new LeafAntGrp(15831, 249, player);
		leafAntGroup.kill();

		// - invisible objects a.k.a triggers
		final leftBound = new FlxObject(0, 663, 35, 167);
		leftBound.add_body({mass: 0});
		final checkpoints = new Checkpoints(player);

		antTrigger = new FlxObject(5580, 726, 49, 106);
		antTrigger.add_body({mass: 0});
		antReturnTrigger = new FlxObject(7244, 726, 49, 106);
		antReturnTrigger.add_body({mass: 0});

		waspFlyByTrigger = new FlxObject(7746, 726, 49, 106);
		waspFlyByTrigger.add_body({mass: 0});

		spiderMovementTrigger = new FlxObject(9817, 729, 49, 106);
		spiderMovementTrigger.add_body({mass: 0});

		cameraUpTrigger = new FlxObject(13076, 58, 49, 106);
		cameraUpTrigger.add_body({mass: 0});
		cameraDownTrigger = new FlxObject(16363, 727, 200, 106);
		cameraDownTrigger.add_body({mass: 0});

		final startAntGroupsTrigger = new FlxObject(13199, 58, 49, 106);
		startAntGroupsTrigger.add_body({mass: 0});

		final pattrollingAntLeftTrigger = new FlxObject(15968, 729, 49, 106);
		pattrollingAntLeftTrigger.add_body({mass: 0});

		final pattrollingAntRightTrigger = new FlxObject(14372, 729, 49, 106);
		pattrollingAntRightTrigger.add_body({mass: 0});

		final waspLandTrigger = new FlxObject(19580, 729, 49, 106);
		waspLandTrigger.add_body({mass: 0});

		final waspFollowPathTrigger = new FlxObject(20357, 245, 49, 106);
		waspFollowPathTrigger.add_body({mass: 0});

		// final movableRockTwoPhysicsTrigger = new FlxObject(20594, 277, 49, 106);
		// movableRockTwoPhysicsTrigger.add_body({mass: 0});

		final rightBound = new FlxObject(23000, 663, 35, 167);
		rightBound.add_body({mass: 0});


		// - environments objects
		final pebbles = new Pebbles(player);
		final hole = new Hole(2721, 828, player);
		final holeTwo = new Hole(8600, 828, player);
		final holeCovering = new FlxSprite((hole.x - 8), (FlxG.height - GROUND_HEIGHT_FROM_BASE + 9));
		holeCovering.makeGraphic(137, GROUND_HEIGHT_FROM_BASE, Colors.groundGreen);
		final holeTwoCovering = new FlxSprite((holeTwo.x - 8), (FlxG.height - GROUND_HEIGHT_FROM_BASE + 9));
		holeTwoCovering.makeGraphic(137, GROUND_HEIGHT_FROM_BASE, Colors.groundGreen);
		final movableRock = new MovableSprite({
			x: 3969,
			y: 728,
			player: player,
			groundListener: groundListener,
		});
		// final movableRockTwo = new MovableSprite({
		// 	x: 20433,
		// 	y: 243,
		// 	player: player,
		// 	groundListener: groundListener,
		// });
		final mushrooms = new Mushrooms(player);
		final plantStem = new PlantStem(4300, -565, player);
		final treeStump = new TreeStump(13108, 164, player);
		final treeStumpCover = new TreeStumpCover(12700, 130);
		final coveringGrass = new CoverGrass(16309, -307);

		// - help text
		// final textPropmpts = new TextPrompts(player);

		// - triggers
		add(leftBound);
		add(antTrigger);
		add(cameraUpTrigger);
		add(cameraDownTrigger);
		add(antReturnTrigger);
		add(waspFlyByTrigger);
		add(spiderMovementTrigger);
		add(startAntGroupsTrigger);

		// - other objects
		add(wasp);
		add(checkpoints);
		add(grpBackground);
		add(groundListener);

		add(treeStump);
		add(leafAntGroup);
		add(coveringGrass);
		add(patrollingAnt);
		add(treeStumpCover);
		add(pebbles);
		add(hole);
		add(holeTwo);
		add(movableRock);
		add(ant);
		add(plantStem);
		add(spider);
		add(mushrooms);
		// add(movableRockTwo);
		add(waspTwo);

		add(playerClimb);
		add(player);
		add(holeCovering);
		add(holeTwoCovering);
		add(rightBound);
		// add(textPropmpts);

		// - physics listeners
		groundListener.listen(player);
		groundListener.listen(spider.sprite);
		leftBound.listen(player);
		rightBound.listen(player, {
			separate: false,
			enter: (_, _, _) -> endOfLevelSet = true,
		});

		ant.listen(groundListener);
		patrollingAnt.listen(groundListener);
		movableRock.sprite.listen(mushrooms.members[0].stalkCollision);

		antTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> ant.state = RunningRight,
		});

		antReturnTrigger.listen(ant, {
			separate: false,
			enter: (_, _, _) -> ant.returnFromMushroomTriggered = true,
		});

		waspFlyByTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> wasp.triggerSkyFly = true,
		});

		spiderMovementTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> spider.startSpiderMovement = true,
		});

		checkpoints.members[2].listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				spider.kill();
				spider.collisionListener.get_body().active = false;
			},
		});

		startAntGroupsTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				leafAntGroup.revive();
				leafAntGroup.startMovement();
				patrollingAnt.state = RunningRight;
			},
		});

		pattrollingAntLeftTrigger.listen(patrollingAnt, {
			separate: false,
			enter: (_, _, _) -> {
				patrollingAnt.state = RunningLeft;
			},
		});

		pattrollingAntRightTrigger.listen(patrollingAnt, {
			separate: false,
			enter: (_, _, _) -> {
				patrollingAnt.state = RunningRight;
			},
		});

		waspLandTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				waspTwo.sprite.flyFromAbove();
			},
		});

		waspFollowPathTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				waspTwo.sprite.followPathSet = true;
			},
		});

		// movableRockTwo.sprite.listen(mushrooms.members[6].sprtImage);
		// movableRockTwo.spaceBuffer.listen(mushrooms.members[6].sprtImage);

		// movableRockTwoPhysicsTrigger.listen(movableRockTwo.sprite, {
		// 	separate: false,
		// 	enter: (_, _, _) -> movableRockTwo.permenantPhysics = true,
		// });
		cameraMovements();

		// - camera settings
		FlxG.worldBounds.set(0, 0, fullMapWidth, FlxG.height);
		FlxG.camera.setScrollBoundsRect(0, 0, fullMapWidth, FlxG.height);
		FlxG.camera.follow(player);
		FlxG.camera.deadzone = FlxRect.get(
			((FlxG.camera.width - (player.width)) / 2) - 300,
			((FlxG.camera.height - player.height) / 2),
			player.width,
			player.height
		);

		if (pixelationSet) { // TODO add pixelation menu option
			var effect = new Pixelate();
			FlxG.camera.setFilters([new ShaderFilter(cast effect)]);
		}
	}

	function cameraMovements() {
		cameraUpTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				if (!cameraUpSet) {
					FlxG.camera.tween({height: FlxG.camera.height + 200}, 1);
					cameraUpSet = true;
				}
			}
		});
		cameraDownTrigger.listen(player, {
			separate: false,
			enter: (_, _, _) -> {
				if (!cameraDownSet) {
					FlxG.camera.tween({height: FlxG.camera.height - 200}, 1);
					cameraDownSet = true;
				}
			}
		});
	}

	function levelResetConditions() {
		groundListener.get_body().active = dataStore.data.enableGroundListener;
		final playerBelowGround = player.get_body().y > FlxG.height;
		if (playerBelowGround || !player.alive) {
			dataStore.data.enableGroundListener = true;
			FlxG.resetState();
		}
	}

	function openEndOfLevelScreen() {
		final levelEndScreen = new LevelComplete();
		FlxG.cameras.fade(Colors.black, 0.5, true);
		openSubState(levelEndScreen);
	}

	function openMainMenu() {
		final mainMenu = new substates.MainMenu();
		openSubState(mainMenu);
	}

	override function update(elapsed: Float) {
		levelResetConditions();

		if (FlxG.keys.pressed.R) {
			FlxG.resetState();
		}

		if (endOfLevelSet) {
			openEndOfLevelScreen();
		}

		if (mainMenuSet) {
			openMainMenu();
		}
		super.update(elapsed);
	}
}
