class_name GameSessionApi


func open_new_game_session(game_save_id: String, on_failure: Callable) -> GameSessionDto:
	var url := Http.api_routes.OPEN_NEW_GAME_SESSION.format({"id": game_save_id})
	var response: HTTPResult = await Http.api_client.post(url, true, {})

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return GameSessionDto.new(json["data"])


func refresh_game_session(game_session_id: String, on_failure: Callable) -> GameSessionDto:
	var response: HTTPResult = await Http.api_client.patch(
		Http.api_routes.REFRESH_GAME_SESSION.format({"game_session_id": game_session_id}), true
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return GameSessionDto.new(json["data"])
