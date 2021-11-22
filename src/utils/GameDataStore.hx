package utils;


class GameDataStore {

  public static final instance: GameDataStore = new GameDataStore();

	public var data: DataFormat = {
		enableGroundListener: true,
		playerPos: {
			x: 93,
			y: 793,
		}
	};

	public function updatePlayerPos(x: Int, y: Int) {
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
	}
};