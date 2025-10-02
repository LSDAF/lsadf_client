class_name InventoryService

var _inventory_data: InventoryData
var _insert_item_queue: Queue
var _update_item_queue: Queue
var _delete_item_queue: Queue

# Mutexes for thread safety
var _insert_mutex: Mutex
var _update_mutex: Mutex
var _delete_mutex: Mutex

var _item_pools: ItemPools = preload("res://src/resources/items/item_pools/item_pools.tres")


func _init(inventory_data: InventoryData) -> void:
	_inventory_data = inventory_data
	_insert_item_queue = Queue.new()
	_update_item_queue = Queue.new()
	_delete_item_queue = Queue.new()
	_insert_mutex = Mutex.new()
	_update_mutex = Mutex.new()
	_delete_mutex = Mutex.new()


func get_items_to_update() -> Array[Item]:
	_update_mutex.lock()
	var items_to_update: Array[Item] = []
	while not _update_item_queue.is_empty():
		items_to_update.push_back(_update_item_queue.dequeue())
	_update_mutex.unlock()
	return items_to_update


func get_items_to_insert() -> Array[Item]:
	_insert_mutex.lock()
	var items_to_insert: Array[Item] = []
	while not _insert_item_queue.is_empty():
		items_to_insert.push_back(_insert_item_queue.dequeue())
	_insert_mutex.unlock()
	return items_to_insert


func get_items_to_delete() -> Array[Item]:
	_delete_mutex.lock()
	var items_to_delete: Array[Item] = []
	while not _delete_item_queue.is_empty():
		items_to_delete.push_back(_delete_item_queue.dequeue())
	_delete_mutex.unlock()
	return items_to_delete


func add_item(item: Item) -> void:
	_inventory_data.items.push_back(item)
	_insert_item_queue.enqueue(item)

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

	var item_to_equip := get_item_from_client_id(item_client_id)

	if item_to_equip == null:
		return

	var item_type := item_to_equip.type

	for index in len(items):
		if items[index].type != item_type:
			continue

		items[index].is_equipped = items[index].client_id == item_client_id
		_update_item_queue.enqueue(items[index])

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
		item.client_id = inventory_item_dto.client_id
		item.blueprint_id = inventory_item_dto.blueprint_id
		item.main_stat = inventory_item_dto.main_stat
		item.additional_stats = inventory_item_dto.additional_stats
		item.rarity = inventory_item_dto.rarity
		item.level = inventory_item_dto.level
		item.type = inventory_item_dto.type
		item.is_equipped = inventory_item_dto.is_equipped

		# Set the texture from the blueprint
		var item_blueprint := _item_pools.get_blueprint_from_id(item.blueprint_id)
		if item_blueprint:
			item.texture = item_blueprint.texture
			item.name = item_blueprint.name

		_inventory_data.items.append(item)


func unequip_item(item_client_id: String) -> void:
	var items := _inventory_data.items
	for item_index in len(items):
		if items[item_index].client_id == item_client_id:
			items[item_index].is_equipped = false

			EventBus.inventory_update.emit()
			return
