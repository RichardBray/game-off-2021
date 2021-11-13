package shaders;

import flixel.system.FlxAssets.FlxShader;

class Pixelate extends FlxShader {
	@:glFragmentSource('
    #pragma header

    void main() {
      vec4 color = texture2D(bitmap, openfl_TextureCoordv);

      float pixels = 4096.0;
      float dx = 15.0 * (1.0 / pixels);
      float dy = 10.0 * (1.0 / pixels);
      vec2 newCoords = vec2(dx * floor(openfl_TextureCoordv.x / dx), dy * floor(openfl_TextureCoordv.y / dy));

      gl_FragColor = texture2D(bitmap, newCoords);
    }')
	public function new() {
		super();
	}
}