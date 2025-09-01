class_name GameSaveApi


func generate_game_save(on_failure: Callable) -> GameSaveDto:
	var response: HTTPResult = await Http.api_client.post(Http.api_routes.GENERATE_GAME_SAVE, true)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return GameSaveDto.new(json["data"]["metadata"])


func update_game_save_nickname(
	game_save_id: String, nickname: String, on_failure: Callable
) -> bool:
	var body: Dictionary = {
		"nickname": nickname,
	}

	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.UPDATE_GAME_SAVE_NICKNAME.format({"game_save_id": game_save_id}), true, body
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return false

	return true
