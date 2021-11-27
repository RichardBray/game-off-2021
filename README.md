# Game off 2021 entry

## Main Tools
- Haxe
- Lix
- HaxeFlixel
- Echo Physics

## Controls

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
- Add trigger to start ant movements when player gets to a certain point
- Make andts loop
- Add eating ants
- Pause screen
- Intro screens
- Background sound?

## Post Jam changes
- Climb down ability
- Add shadow
- Roll animation for jumping off high points
- Increment deaths