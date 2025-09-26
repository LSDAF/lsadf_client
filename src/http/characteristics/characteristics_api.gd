class_name CharacteristicsApi


func fetch_game_save_characteristics(
	game_save_id: String, on_failure: Callable
) -> FetchCharacteristicsDto:
	var response: HTTPResult = await Http.api_client.fetch(
		Http.api_routes.FETCH_GAME_SAVES_CHARACTERISTICS.format({"game_save_id": game_save_id}),
		true
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

	return FetchCharacteristicsDto.new(json["data"])


func update_game_save_characteristics(
	game_save_id: String,
	game_session_id: String,
	update_characteristics_dto: UpdateCharacteristicsDto,
	on_failure: Callable
) -> bool:
	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.UPDATE_GAME_SAVE_CHARACTERISTICS.format({"game_save_id": game_save_id}),
		true,
		update_characteristics_dto.to_dictionary(),
		{"X-GameSession-ID": game_session_id}
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return false

	return true
