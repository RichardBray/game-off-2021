package utils;

typedef StorageFormat = {
  var enableGroundListener: Bool;
	var checkpointPos: {
		x: Int,
		y: Int,
	}
};

class GameDataStore {
  public static final instance: GameDataStore = new GameDataStore();

	public var data:StorageFormat = {
		enableGroundListener: true,
		checkpointPos: {
			x: 0,
			y: 0,
		}
	};

	public function setDefaults() {
		data.enableGroundListener = true;
		data.checkpointPos = {
			x: 0,
			y: 0,
		};
	}

	private function new() {}
}