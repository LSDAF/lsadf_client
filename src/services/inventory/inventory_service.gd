class_name InventoryService

var _inventory_data: InventoryData


func _init(inventory_data: InventoryData) -> void:
	_inventory_data = inventory_data


func add_item(item: Item) -> void:
	_inventory_data.items.push_back(item)

	EventBus.inventory_update.emit()


func delete_item(item_client_id: String) -> void:
	var items := _inventory_data.items

	var item_to_delete_index := ArrayUtils.find_index_predicate(
		items, func(item: Item) -> bool: return item.client_id == item_client_id
	)

	if item_to_delete_index == -1:
		return

	items.pop_at(item_to_delete_index)

	EventBus.inventory_update.emit()


func equip_item(item_client_id: String) -> void:
	var items := _inventory_data.items

	var item_to_equip_index := ArrayUtils.find_index_predicate(
		items, func(item: Item) -> bool: return item.client_id == item_client_id
	)

	if item_to_equip_index == -1:
		return

	var item_type := items[item_to_equip_index].type

	for index in len(items):
		if items[index].type != item_type:
			continue

		items[index].is_equipped = index == item_to_equip_index

	EventBus.inventory_update.emit()


func get_items() -> Array[Item]:
	return _inventory_data.items


func get_equipped_items_client_id() -> Array[String]:
	var items := _inventory_data.items
	var equipped_items_index: Array[String] = []

	for item_index in len(items):
		if items[item_index].is_equipped:
			equipped_items_index.push_back(items[item_index].client_id)

	return equipped_items_index


func get_item_from_client_id(item_client_id: String) -> Item:
	var items := _inventory_data.items
	for item_index in len(items):
		if items[item_index].client_id == item_client_id:
			return items[item_index]

	return null


func level_up_item(item_client_id: String) -> void:
	var items := _inventory_data.items
	for item_index in len(items):
		if items[item_index].client_id == item_client_id:
			items[item_index].level += 1

			EventBus.inventory_update.emit()
			return


func set_inventory_from_fetch_inventory_dto(fetch_inventory_dto: FetchInventoryDto) -> void:
	_inventory_data.items = []

	for inventory_item_dto in fetch_inventory_dto.items:
		var item := Item.new()
		item.main_stat = inventory_item_dto.main_stat
		item.additional_stats = inventory_item_dto.additional_stats
		item.rarity = inventory_item_dto.rarity
		item.level = inventory_item_dto.level
		item.type = inventory_item_dto.type
		item.is_equipped = inventory_item_dto.is_equipped
		_inventory_data.items.append(item)


func unequip_item(item_client_id: String) -> void:
	var items := _inventory_data.items
	for item_index in len(items):
		if items[item_index].client_id == item_client_id:
			items[item_index].is_equipped = false

			EventBus.inventory_update.emit()
			return
