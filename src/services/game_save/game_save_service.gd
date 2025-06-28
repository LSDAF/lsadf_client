class_name GameSaveService

var _characteristics_api: CharacteristicsApi
var _currency_api: CurrenciesApi
var _inventory_api: InventoryApi
var _stage_api: StageApi
var _clock_service: ClockService
var _characteristics_service: CharacteristicsService
var _currency_service: CurrenciesService
var _inventory_service: InventoryService
var _stage_service: StageService
var _game_save_data: GameSaveData


func _init(
	characteristics_api: CharacteristicsApi,
	currency_api: CurrenciesApi,
	inventory_api: InventoryApi,
	stage_api: StageApi,
	clock_service: ClockService,
	characteristics_service: CharacteristicsService,
	currency_service: CurrenciesService,
	inventory_service: InventoryService,
	stage_service: StageService,
	game_save_data: GameSaveData,
) -> void:
	_characteristics_api = characteristics_api
	_currency_api = currency_api
	_inventory_api = inventory_api
	_stage_api = stage_api
	_clock_service = clock_service
	_characteristics_service = characteristics_service
	_currency_service = currency_service
	_inventory_service = inventory_service
	_stage_service = stage_service
	_game_save_data = game_save_data


func get_game_save_id() -> String:
	return _game_save_data._game_save_id


func load_game_save(game_save_id: String) -> void:
	_game_save_data._game_save_id = game_save_id

	var fetched_characteristics := await _characteristics_api.fetch_game_save_characteristics(
		_game_save_data._game_save_id, _on_fetch_characteristics_error
	)
	_characteristics_service._set_characteristics(
		fetched_characteristics.attack,
		fetched_characteristics.crit_chance,
		fetched_characteristics.crit_damage,
		fetched_characteristics.health,
		fetched_characteristics.resistance
	)

	var fetched_currencies := await _currency_api.fetch_game_save_currencies(
		_game_save_data._game_save_id, _on_fetch_currencies_error
	)
	_currency_service._set_currencies(
		fetched_currencies.gold,
		fetched_currencies.diamond,
		fetched_currencies.emerald,
		fetched_currencies.amethyst
	)

	var fetched_inventory := await _inventory_api.fetch_game_save_inventory(
		_game_save_data._game_save_id, _on_fetch_inventory_error
	)
	_inventory_service.set_inventory_from_fetch_inventory_dto(fetched_inventory)

	var fetched_stage := await _stage_api.fetch_game_save_stage(
		_game_save_data._game_save_id, _on_fetch_stage_error
	)
	_stage_service.set_current_stage(fetched_stage.current_stage)
	_stage_service.set_max_stage(fetched_stage.max_stage)


func save_game() -> void:
	var success := (
		await _save_currencies()
		and await _save_stage()
		and await _save_characteristics()
		and await _save_inventory()
	)

	if success:
		_game_save_data._last_save_time = _clock_service.get_unix_time_from_system()
		Services.toaster.toast("Game saved.")
		print("Game Saved")
	else:
		Services.toaster.toast("Failed to save game.")
		print("Failed to save game.")


func _save_characteristics() -> bool:
	var update_characteristics_dto := (
		UpdateCharacteristicsDto
		. new(
			{
				"attack": Data.characteristics.attack.get_level(),
				"crit_chance": Data.characteristics.crit_chance.get_level(),
				"crit_damage": Data.characteristics.crit_damage.get_level(),
				"health": Data.characteristics.health.get_level(),
				"resistance": Data.characteristics.resistance.get_level(),
			}
		)
	)

	return await _characteristics_api.update_game_save_characteristics(
		_game_save_data._game_save_id, update_characteristics_dto, _on_save_characteristics_error
	)


func _save_currencies() -> bool:
	var update_currencies_dto := (
		UpdateCurrenciesDto
		. new(
			{
				"gold": Data.currencies.gold.get_value(),
				"diamond": Data.currencies.diamond.get_value(),
				"emerald": Data.currencies.emerald.get_value(),
				"amethyst": Data.currencies.amethyst.get_value(),
			}
		)
	)

	return await _currency_api.update_game_save_currencies(
		Data.game_save._game_save_id, update_currencies_dto, _on_save_currencies_error
	)


func _save_stage() -> bool:
	var update_stage_dto := (
		UpdateStageDto
		. new(
			{
				"current_stage": _stage_service.get_current_stage(),
				"max_stage": _stage_service.get_max_stage(),
			}
		)
	)

	return await _stage_api.update_game_save_stage(
		_game_save_data._game_save_id, update_stage_dto, _on_save_stage_error
	)


func _convert_item_to_dto(item: Item) -> InventoryItemDto:
	return InventoryItemDto.new(
		{
			"client_id": item.client_id,
			"base_id": item.base_id,
			"main_stat": ItemStat.to_dictionary(item.main_stat),
			"additional_stats": item.additional_stats.map(ItemStat.to_dictionary),
			"rarity": ItemRarity.ItemRarity.keys()[item.rarity],
			"level": item.level,
			"type": ItemType.ItemType.keys()[item.type],
			"is_equipped": item.is_equipped
		}
	)


func _get_local_items_dto() -> Array[InventoryItemDto]:
	var local_items := _inventory_service.get_items()
	var local_items_dto: Array[InventoryItemDto] = []

	for item in local_items:
		local_items_dto.append(_convert_item_to_dto(item))

	return local_items_dto


func _organize_items(
	db_inventory: FetchInventoryDto, local_items_dto: Array[InventoryItemDto]
) -> Dictionary:
	var db_items_by_client_id: Dictionary = {}
	for db_item: InventoryItemDto in db_inventory.items:
		db_items_by_client_id[db_item.client_id] = db_item

	var local_items_by_client_id: Dictionary = {}
	for local_item: InventoryItemDto in local_items_dto:
		local_items_by_client_id[local_item.client_id] = local_item

	var items_to_delete: Array[String] = []
	var items_to_update: Array[InventoryItemDto] = []
	var items_to_create: Array[InventoryItemDto] = []

	# Find items to delete and update
	for db_client_id: String in db_items_by_client_id.keys():
		if not local_items_by_client_id.has(db_client_id):
			items_to_delete.append(db_client_id)
		else:
			items_to_update.append(local_items_by_client_id[db_client_id])

	# Find items to create
	for local_client_id: String in local_items_by_client_id.keys():
		if not db_items_by_client_id.has(local_client_id):
			items_to_create.append(local_items_by_client_id[local_client_id])

	return {
		"items_to_delete": items_to_delete,
		"items_to_update": items_to_update,
		"items_to_create": items_to_create
	}


func _execute_inventory_operations(
	items_to_delete: Array[String],
	items_to_create: Array[InventoryItemDto],
	items_to_update: Array[InventoryItemDto]
) -> bool:
	var success: bool = true

	# Delete items
	for client_id in items_to_delete:
		if not await _inventory_api.delete_game_save_inventory_item(
			_game_save_data._game_save_id, client_id, _on_save_inventory_error
		):
			success = false

	# Create new items
	for item in items_to_create:
		if not await _inventory_api.create_game_save_inventory_item(
			_game_save_data._game_save_id, item, _on_save_inventory_error
		):
			success = false

	# Update existing items
	for item in items_to_update:
		if not await _inventory_api.update_game_save_inventory_item(
			_game_save_data._game_save_id, item, _on_save_inventory_error
		):
			success = false

	return success


func _save_inventory() -> bool:
	# 1. Get current inventory from DB
	var db_inventory: FetchInventoryDto = await _inventory_api.fetch_game_save_inventory(
		_game_save_data._game_save_id, _on_fetch_inventory_error
	)
	if not db_inventory:
		return false

	# 2. Convert local items to DTOs
	var local_items_dto := _get_local_items_dto()

	# 3. Compare and organize items
	var organized_items := _organize_items(db_inventory, local_items_dto)

	# 4. Execute operations
	return await _execute_inventory_operations(
		organized_items["items_to_delete"],
		organized_items["items_to_create"],
		organized_items["items_to_update"]
	)


func _on_fetch_characteristics_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch characteristics.")
	print(response)


func _on_fetch_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch currencies.")
	print(response)


func _on_fetch_inventory_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch inventory.")
	print(response)


func _on_fetch_stage_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch stage.")
	print(response)


func _on_save_characteristics_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save characteristics.")
	print(response)


func _on_save_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save currencies.")
	print(response)


func _on_save_stage_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save stage.")
	print(response)


func _on_save_inventory_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save inventory item.")
	print(response)
