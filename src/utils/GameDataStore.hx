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

	// public function setDefaults() {
	// 	data.enableGroundListener = true;
	// 	data.playerPos = {
	// 		x: 93,
	// 		y: 173,
	// 	};
	// }

	private function new() {}
}

typedef DataFormat = {
  var enableGroundListener: Bool;
	var playerPos: {
		x: Int,
		y: Int,
	}
};