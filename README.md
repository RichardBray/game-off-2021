# Game off 2021 entry

## Main Tech
- Haxe
- HaxeFlixel
- Echo Physics

## Dev Tech
- Lix
- NPM
- Concurrently
- Watchman
- Http Server
## Controls
- A, Left arrow: Move right
- D, Right arrow: Move left
- W, Up arrow, Spacebar: Jump
- Shift: Push objects
- R: Reset to last checkpoint
- ESC: Pause

---
## Dev Notes

js.Browser.console.log();
js.Lib.Debug();
### Installing Echo-Flixel with Lix
```
lix install gh:AustinEast/echo-flixel
```

### Adjusting player deadzone helper
```haxe
final deadZone = new FlxSprite(((FlxG.camera.width - (player.width)) / 2) - 200, ((FlxG.camera.height - player.height) / 2 - player.height * 0.25)).makeGraphic(Std.int(player.width), Std.int(player.height), 0xFF000000);
add(deadZone);
```

```js
var a = 35;
var b = 237;
var y = [[71, 138], [125, 88.5], [205.5, 48], [275, 33], [350, 39.5], [418, 65.5], [445.5, 88.5]];
var newY = y.map(x =>  [x[0] - a, x[1] - b]);
```

## Todo
- Finish adding sounds
- Add text prompts
- Pause screen
- Fix pixel mode

## Post Jam changes
- Gamepad controls
- Screen shake if player jumps too high
- Climb down ability
- Add shadow
- Roll animation for jumping off high points
- Increment deaths
