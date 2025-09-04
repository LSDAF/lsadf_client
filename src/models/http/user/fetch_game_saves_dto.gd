class_name FetchGameSavesDto

var game_saves: Array[GameSaveDto]


func _init(dictionary: Array) -> void:
	for game_save: Dictionary in dictionary:
		game_saves.push_back(GameSaveDto.new(game_save["metadata"]))
