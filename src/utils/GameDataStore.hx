package utils;

typedef StorageFormat = {
  var enableGroundListener: Bool;
};

class GameDataStore {
  public static final instance: GameDataStore = new GameDataStore();

	public var data:StorageFormat = {
		enableGroundListener: true,
	};

	private function new() {
	}
}