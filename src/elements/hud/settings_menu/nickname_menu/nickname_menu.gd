extends CenterContainer

var _new_nickname: String


func _on_error(response: Variant) -> void:
	Services.toaster.toast("Error when updating your nickname")
	print_debug(response)


func _on_line_edit_text_changed(new_text: String) -> void:
	_new_nickname = new_text


func _on_button_pressed() -> void:
	var game_save_id := Services.game_save.get_game_save_id()
	var success := await Api.game_save.update_game_save_nickname(
		game_save_id, _new_nickname, _on_error
	)

	if success:
		queue_free()
