extends GutTest

var sut: InventoryService

var inventory_data := preload("res://src/data/inventory/inventory_data.gd")
var inventory_data_partial_double: Variant


func before_each() -> void:
	inventory_data_partial_double = partial_double(inventory_data).new()

	sut = preload("res://src/services/inventory/inventory_service.gd").new(
		inventory_data_partial_double
	)


func test_add_item() -> void:
	# Arrange
	var item := Item.new()
	item.name = "item"

	# Act
	sut.add_item(item)

	# Assert
	assert_eq(inventory_data_partial_double.items.size(), 1)
	assert_eq(inventory_data_partial_double.items[0].name, "item")
	assert_eq(inventory_data_partial_double.items[0], item)


func test_delete_item() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "36f27c2a-06e8-4bdb-bf59-56999116f5ef__11111111-1111-1111-1111-111111111111"
	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "36f27c2a-06e8-4bdb-bf59-56999116f5ef__22222222-2222-2222-2222-222222222222"

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	sut.delete_item("36f27c2a-06e8-4bdb-bf59-56999116f5ef__11111111-1111-1111-1111-111111111111")

	# Assert
	assert_eq(inventory_data_partial_double.items.size(), 1)
	assert_eq(inventory_data_partial_double.items[0].name, "item_1")


func test_equip_item_at_index() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "36f27c2a-06e8-4bdb-bf59-56999116f5ef__11111111-1111-1111-1111-111111111111"
	item_0.is_equipped = true
	item_0.type = ItemType.ItemType.SWORD

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "36f27c2a-06e8-4bdb-bf59-56999116f5ef__22222222-2222-2222-2222-222222222222"
	item_1.is_equipped = false
	item_1.type = ItemType.ItemType.SWORD

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.client_id = "36f27c2a-06e8-4bdb-bf59-56999116f5ef__33333333-3333-3333-3333-333333333333"
	item_2.is_equipped = true
	item_2.type = ItemType.ItemType.SHIELD

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)
	inventory_data_partial_double.items.push_back(item_2)

	# Act
	sut.equip_item("36f27c2a-06e8-4bdb-bf59-56999116f5ef__22222222-2222-2222-2222-222222222222")

	# Assert
	assert_eq(inventory_data_partial_double.items[0].is_equipped, false)
	assert_eq(inventory_data_partial_double.items[1].is_equipped, true)
	assert_eq(inventory_data_partial_double.items[2].is_equipped, true)


func test_get_items() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	var item_1 := Item.new()
	item_1.name = "item_1"

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	var items: Array[Item] = sut.get_items()

	# Assert
	assert_eq(items.size(), 2)
	assert_eq(items[0].name, "item_0")
	assert_eq(items[1].name, "item_1")


func test_get_equipped_items_client_id() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "item_0"
	item_0.is_equipped = true
	item_0.type = ItemType.ItemType.SWORD

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "item_1"
	item_1.is_equipped = false
	item_1.type = ItemType.ItemType.SWORD

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.client_id = "item_2"
	item_2.is_equipped = true
	item_2.type = ItemType.ItemType.SHIELD

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)
	inventory_data_partial_double.items.push_back(item_2)

	# Act
	var equipped_items_index: Array[String] = sut.get_equipped_items_client_id()

	# Assert
	assert_eq(equipped_items_index.size(), 2)
	assert_eq(equipped_items_index[0], "item_0")
	assert_eq(equipped_items_index[1], "item_2")


func test_get_item_from_client_id() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "item_0"
	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "item_1"

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	var item: Item = sut.get_item_from_client_id("item_1")

	# Assert
	assert_eq(item.name, "item_1")


func test_level_up_item() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "item_0"
	item_0.level = 1

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "item_1"
	item_1.level = 2

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)

	# Act
	sut.level_up_item("item_1")

	# Assert
	assert_eq(inventory_data_partial_double.items[0].level, 1)
	assert_eq(inventory_data_partial_double.items[1].level, 3)


func test_set_inventory_from_fetch_inventory_dto() -> void:
	# Arrange
	var test_base_1 := ItemBase.new()
	test_base_1.id = "sword_normal_1"
	test_base_1.name = "Test Sword"
	test_base_1.texture = null

	var test_base_2 := ItemBase.new()
	test_base_2.id = "sword_normal_2"
	test_base_2.name = "Test Chestplate"
	test_base_2.texture = null

	# Mock get_base_from_id to return our test bases
	var item_bases_service_double: ItemBasesService = double(ItemBasesService).new()
	stub(item_bases_service_double, "get_base_from_id").to_return(test_base_1).when_passed(
		"sword_normal_1"
	)
	stub(item_bases_service_double, "get_base_from_id").to_return(test_base_2).when_passed(
		"sword_normal_2"
	)
	sut._item_bases_service = item_bases_service_double

	var fetch_inventory_dto := (
		FetchInventoryDto
		. new(
			{
				"items":
				[
					{
						"client_id":
						"36f27c2a-06e8-4bdb-bf59-56999116f5ef__11111111-1111-1111-1111-111111111111",
						"base_id": "sword_normal_1",
						"main_stat": {"statistic": "ATTACK_ADD", "base_value": 1.0},
						"additional_stats": [{"statistic": "CRIT_DAMAGE", "base_value": 3.0}],
						"rarity": "NORMAL",
						"level": 1,
						"type": "SWORD",
						"is_equipped": false,
					},
					{
						"client_id":
						"36f27c2a-06e8-4bdb-bf59-56999116f5ef__22222222-2222-2222-2222-222222222222",
						"base_id": "sword_normal_2",
						"main_stat": {"statistic": "CRIT_CHANCE", "base_value": 2.0},
						"additional_stats": [{"statistic": "HEALTH_ADD", "base_value": 4.0}],
						"rarity": "NORMAL",
						"level": 10,
						"type": "CHESTPLATE",
						"is_equipped": true,
					}
				]
			}
		)
	)

	# Act
	sut.set_inventory_from_fetch_inventory_dto(fetch_inventory_dto)

	# Assert
	assert_eq(inventory_data_partial_double.items.size(), 2)

	# Verify first item
	var item: Item = inventory_data_partial_double.items[0]
	assert_eq(
		item.client_id, "36f27c2a-06e8-4bdb-bf59-56999116f5ef__11111111-1111-1111-1111-111111111111"
	)
	assert_eq(item.main_stat.statistic, ItemStatistics.ItemStatistics.ATTACK_ADD)
	assert_eq(item.main_stat.base_value, 1.0)
	assert_eq(item.additional_stats[0].statistic, ItemStatistics.ItemStatistics.CRIT_DAMAGE)
	assert_eq(item.additional_stats[0].base_value, 3.0)
	assert_eq(item.rarity, ItemRarity.ItemRarity.NORMAL)
	assert_eq(item.level, 1)
	assert_eq(item.type, ItemType.ItemType.SWORD)
	assert_eq(item.is_equipped, false)
	# Verify texture and name are set from the base
	assert_eq(item.texture, test_base_1.texture)
	assert_eq(item.name, test_base_1.name)

	# Verify second item
	item = inventory_data_partial_double.items[1]
	assert_eq(
		item.client_id, "36f27c2a-06e8-4bdb-bf59-56999116f5ef__22222222-2222-2222-2222-222222222222"
	)
	assert_eq(item.main_stat.statistic, ItemStatistics.ItemStatistics.CRIT_CHANCE)
	assert_eq(item.main_stat.base_value, 2.0)
	assert_eq(item.additional_stats[0].statistic, ItemStatistics.ItemStatistics.HEALTH_ADD)
	assert_eq(item.additional_stats[0].base_value, 4.0)
	assert_eq(item.rarity, ItemRarity.ItemRarity.NORMAL)
	assert_eq(item.level, 10)
	assert_eq(item.type, ItemType.ItemType.CHESTPLATE)
	assert_eq(item.is_equipped, true)
	# Verify texture and name are set from the base
	assert_eq(item.texture, test_base_2.texture)
	assert_eq(item.name, test_base_2.name)


func test_unequip_item() -> void:
	# Arrange
	var item_0 := Item.new()
	item_0.name = "item_0"
	item_0.client_id = "item_0"
	item_0.is_equipped = true
	item_0.type = ItemType.ItemType.SWORD

	var item_1 := Item.new()
	item_1.name = "item_1"
	item_1.client_id = "item_1"
	item_1.is_equipped = false
	item_1.type = ItemType.ItemType.SWORD

	var item_2 := Item.new()
	item_2.name = "item_2"
	item_2.client_id = "item_2"
	item_2.is_equipped = true
	item_2.type = ItemType.ItemType.SHIELD

	inventory_data_partial_double.items.push_back(item_0)
	inventory_data_partial_double.items.push_back(item_1)
	inventory_data_partial_double.items.push_back(item_2)

	# Act
	sut.unequip_item("item_0")

	# Assert
	assert_eq(inventory_data_partial_double.items[0].is_equipped, false)
	assert_eq(inventory_data_partial_double.items[1].is_equipped, false)
	assert_eq(inventory_data_partial_double.items[2].is_equipped, true)
