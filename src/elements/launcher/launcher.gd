class_name Launcher
extends Control

signal game_loaded

@export var game_save_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LoginRegister.on_login.connect(login)
	%LoginRegister.on_oauth_login.connect(oauth_login)
	set_process(true)

	if await Services.user_local_data.relog_user() == true:
		fetch_game_saves()


func fetch_game_saves() -> void:
	%LoginRegister.hide()
	%GameSavesCenterContainer.show()

	var game_saves: FetchGameSavesDto = await Api.user.fetch_game_saves(_on_fetch_game_saves_error)

	for game_save_dto in game_saves.game_saves:
		var game_save: GameSaveButton = game_save_scene.instantiate()
		game_save.initialize(game_save_dto, _on_game_loaded)

		%GameSavesVBoxContainer.add_child(game_save)


func oauth_login(access_token: String, refresh_token: String) -> void:
	print_debug("[launcher.gd][oauth_login()] Access token: %s" % access_token)
	print_debug("[launcher.gd][oauth_login()] Refresh token: %s" % refresh_token)
	fetch_game_saves()


func login(email: String, password: String) -> void:
	var login_response: LoginResponseDto = await Api.auth.login(email, password, _on_login_error)

	if login_response == null:
		return

	Services.user_local_data.save_access_token(login_response.access_token)
	Services.user_local_data.save_refresh_token(login_response.refresh_token)

	fetch_game_saves()


func return_to_login_form() -> void:
	%LoginRegister.show()
	%GameSavesCenterContainer.hide()

	for child in %GameSavesVBoxContainer.get_children():
		child.queue_free()


func _on_generate_game_save_error(response: Variant) -> void:
	Services.toaster.toast("Error when generating save")
	print_debug(response)


func _on_login_error(response: Variant) -> void:
	Services.toaster.toast("Error when logging in")
	print_debug(response)


func _on_fetch_game_saves_error(response: Variant) -> void:
	Services.toaster.toast("Error when fetching games")
	print_debug(response)

	Services.user_local_data.create_new_user_data()
	return_to_login_form()


func _on_game_loaded() -> void:
	game_loaded.emit()


func _on_create_new_game_button_pressed() -> void:
	var game_save_dto: GameSaveDto = await Api.game_save.generate_game_save(
		_on_generate_game_save_error
	)

	var game_save: GameSaveButton = game_save_scene.instantiate()
	game_save.initialize(game_save_dto, _on_game_loaded)

	%GameSavesVBoxContainer.add_child(game_save)
