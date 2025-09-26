class_name GameSaveButton
extends Control

signal game_loaded

var _game_save_dto: GameSaveDto


func _ready() -> void:
	%GameNameLabel.text = _game_save_dto.nickname
	%GameCreatedAtLabel.text = "Created: {0}".format(
		[Time.get_datetime_string_from_unix_time(_game_save_dto.created_at)]
	)


func initialize(game_save_dto: GameSaveDto, on_game_loaded: Callable) -> void:
	_game_save_dto = game_save_dto
	game_loaded.connect(on_game_loaded)


func _on_pressed() -> void:
	await Services.game_session.open_new_game_session(_game_save_dto.id)
	await Services.game_save.load_game_save(_game_save_dto.id)
	game_loaded.emit()
