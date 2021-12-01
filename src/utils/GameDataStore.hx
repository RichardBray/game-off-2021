package utils;


class GameDataStore {

  public static final instance: GameDataStore = new GameDataStore();

	public var data: DataFormat = {
		enableGroundListener: true,
		playerPos: {
			x: 93, // 22080
			y: 793, // 793
		},
		pixelMode: false,
	};

	public function setPlayerPos(x: Int, y: Int) {
		data.playerPos.x = x;
		data.playerPos.y = y;
	}

	private function new() {}
}

typedef DataFormat = {
  var enableGroundListener: Bool;
	var playerPos: {
		x: Int,
		y: Int,
	};
	var pixelMode: Bool;
};