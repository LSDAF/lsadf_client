class_name InventoryApi


func create_game_save_inventory_item(
	game_save_id: String, game_session_id: String, item: InventoryItemDto, on_failure: Callable
) -> bool:
	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.CREATE_GAME_SAVE_INVENTORY_ITEM.format({"game_save_id": game_save_id}),
		true,
		item.to_dictionary(),
		{"X-GameSession-ID": game_session_id}
	)

	if !response.success() or response.status_err():
		on_failure.call(response)
		push_error("Request failed.")
		return false

	var json: Dictionary = response.body_as_json()

	if not json:
		on_failure.call(response)
		push_error("JSON invalid.")
		return false

	return true


func delete_game_save_inventory_item(
	game_save_id: String, client_id: String, game_session_id: String, on_failure: Callable
) -> bool:
	var response: HTTPResult = await Http.api_client.delete(
		Http.api_routes.DELETE_GAME_SAVE_INVENTORY_ITEM.format(
			{"game_save_id": game_save_id, "client_id": client_id}
		),
		true,
		{"X-GameSession-ID": game_session_id}
	)

	if !response.success() or response.status_err():
		on_failure.call(response)
		push_error("Request failed.")
		return false

	var json: Dictionary = response.body_as_json()

	if not json:
		on_failure.call(response)
		push_error("JSON invalid.")
		return false

	return true


func fetch_game_save_inventory(game_save_id: String, on_failure: Callable) -> FetchInventoryDto:
	var response: HTTPResult = await Http.api_client.fetch(
		Http.api_routes.FETCH_GAME_SAVES_INVENTORY.format({"game_save_id": game_save_id}), true
	)

	if !response.success() or response.status_err():
		on_failure.call(response)
		push_error("Request failed.")
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		on_failure.call(response)
		push_error("JSON invalid.")
		return null

	return FetchInventoryDto.new(json["data"])


func update_game_save_inventory_item(
	game_save_id: String, game_session_id: String, item: InventoryItemDto, on_failure: Callable
) -> bool:
	var response: HTTPResult = await Http.api_client.put(
		Http.api_routes.UPDATE_GAME_SAVE_INVENTORY_ITEM.format(
			{"game_save_id": game_save_id, "client_id": item.client_id}
		),
		true,
		item.to_dictionary(),
		{"X-GameSession-ID": game_session_id}
	)

	if !response.success() or response.status_err():
		on_failure.call(response)
		push_error("Request failed.")
		return false

	var json: Dictionary = response.body_as_json()

	if not json:
		on_failure.call(response)
		push_error("JSON invalid.")
		return false

	return true
