extends GutTest

var sut: GameSaveService

var characteristics_api := preload("res://src/http/characteristics/characteristics_api.gd")
var currencies_api := preload("res://src/http/currencies/currencies_api.gd")
var inventory_api := preload("res://src/http/inventory/inventory_api.gd")
var stage_api := preload("res://src/http/stage/stage_api.gd")
var characteristics_data := preload("res://src/data/characteristics/characteristics_data.gd")
var currency_data := preload("res://src/data/currencies/currencies_data.gd")
var difficulty_data := preload("res://src/data/difficulty/difficulty_data.gd")
var game_save_data := preload("res://src/data/game_save/game_save_data.gd")
var inventory_data := preload("res://src/data/inventory/inventory_data.gd")
var stage_data := preload("res://src/data/stage/stage_data.gd")
var characteristics_service := preload(
	"res://src/services/characteristics/characteristics_service.gd"
)
var currencies_service := preload("res://src/services/currencies/currencies_service.gd")
var clock_service := preload("res://src/services/clock/clock_service.gd")
var current_quest_service := preload("res://src/services/current_quest/current_quest_service.gd")
var difficulty_service := preload("res://src/services/difficulty/difficulty_service.gd")
var inventory_service := preload("res://src/services/inventory/inventory_service.gd")
var stage_service := preload("res://src/services/stage/stage_service.gd")

var characteristics_api_partial_double: Variant
var currencies_api_partial_double: Variant
var inventory_api_partial_double: Variant
var stage_api_partial_double: Variant
var characteristics_data_partial_double: Variant
var currency_data_partial_double: Variant
var difficulty_data_partial_double: Variant
var game_save_data_partial_double: Variant
var inventory_data_partial_double: Variant
var stage_data_partial_double: Variant
var characteristics_service_partial_double: Variant
var currencies_service_partial_double: Variant
var clock_service_partial_double: Variant
var current_quest_service_partial_double: Variant
var difficulty_service_partial_double: Variant
var inventory_service_partial_double: Variant
var stage_service_partial_double: Variant


func before_each() -> void:
	characteristics_data_partial_double = partial_double(characteristics_data).new()
	currency_data_partial_double = partial_double(currency_data).new()
	difficulty_data_partial_double = partial_double(difficulty_data).new()
	inventory_data_partial_double = partial_double(inventory_data).new()
	stage_data_partial_double = partial_double(stage_data).new()

	characteristics_api_partial_double = partial_double(characteristics_api).new()
	currencies_api_partial_double = partial_double(currencies_api).new()
	inventory_api_partial_double = partial_double(inventory_api).new()
	stage_api_partial_double = partial_double(stage_api).new()
	clock_service_partial_double = partial_double(clock_service).new()
	current_quest_service_partial_double = partial_double(current_quest_service).new()
	difficulty_service_partial_double = partial_double(difficulty_service).new(
		difficulty_data_partial_double
	)
	characteristics_service_partial_double = partial_double(characteristics_service).new(
		characteristics_data_partial_double
	)
	currencies_service_partial_double = partial_double(currencies_service).new(
		currency_data_partial_double
	)
	inventory_service_partial_double = partial_double(inventory_service).new(
		inventory_data_partial_double
	)
	stage_service_partial_double = partial_double(stage_service).new(
		stage_data_partial_double,
		current_quest_service_partial_double,
		difficulty_service_partial_double
	)
	game_save_data_partial_double = partial_double(game_save_data).new()

	sut = preload("res://src/services/game_save/game_save_service.gd").new(
		characteristics_api_partial_double,
		currencies_api_partial_double,
		inventory_api_partial_double,
		stage_api_partial_double,
		clock_service_partial_double,
		characteristics_service_partial_double,
		currencies_service_partial_double,
		inventory_service_partial_double,
		stage_service_partial_double,
		game_save_data_partial_double
	)


func test_get_game_save_id() -> void:
	# Arrange
	game_save_data_partial_double._game_save_id = "game_save_id"

	# Act
	var game_save_id: String = sut.get_game_save_id()

	# Assert
	assert_eq(game_save_id, "game_save_id")


func test_load_game_save() -> void:
	# Arrange
	var fetched_characteristics: FetchCharacteristicsDto = FetchCharacteristicsDto.new(
		{"attack": 100, "crit_chance": 100, "crit_damage": 100, "health": 100, "resistance": 100}
	)
	var fetched_currencies: CurrenciesDto = CurrenciesDto.new(
		{"gold": 1000, "diamond": 2000, "emerald": 3000, "amethyst": 4000}
	)
	var fetched_stage: FetchStageDto = FetchStageDto.new({"current_stage": 100, "max_stage": 200})

	var fetched_inventory: FetchInventoryDto = FetchInventoryDto.new({"items": []})

	stub(characteristics_api_partial_double, "fetch_game_save_characteristics").to_return(
		fetched_characteristics
	)
	stub(currencies_api_partial_double, "fetch_game_save_currencies").to_return(fetched_currencies)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(fetched_inventory)
	stub(stage_api_partial_double, "fetch_game_save_stage").to_return(fetched_stage)

	# Act
	sut.load_game_save("game_save_id")

	# Assert
	assert_eq(currency_data_partial_double.gold._value, 1000)
	assert_eq(currency_data_partial_double.diamond._value, 2000)
	assert_eq(currency_data_partial_double.emerald._value, 3000)
	assert_eq(currency_data_partial_double.amethyst._value, 4000)

	assert_eq(stage_data_partial_double._current_stage, 100)
	assert_eq(stage_data_partial_double._max_stage, 200)

	assert_eq(characteristics_data_partial_double.attack._level, 100)
	assert_eq(characteristics_data_partial_double.crit_chance._level, 100)
	assert_eq(characteristics_data_partial_double.crit_damage._level, 100)
	assert_eq(characteristics_data_partial_double.health._level, 100)
	assert_eq(characteristics_data_partial_double.resistance._level, 100)

	assert_eq(inventory_data_partial_double.items.size(), 0)

	assert_eq(difficulty_data_partial_double._current_difficulty, 100.0)


func test_save_game_success() -> void:
	# Arrange
	stub(clock_service_partial_double, "get_unix_time_from_system").to_return(1000.0)

	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(true)
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(true)
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(true)
	var items: Array[Item] = []
	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new({"items": []})
	)

	# Act
	await sut.save_game()

	# Assert
	assert_eq(game_save_data_partial_double._last_save_time, 1000.0)


func test_save_game_partial_failure() -> void:
	# Arrange
	stub(clock_service_partial_double, "get_unix_time_from_system").to_return(1000.0)

	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(true)
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(false)
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(false)
	var items: Array[Item] = []
	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new({"items": []})
	)

	# Act
	await sut.save_game()

	# Assert
	assert_eq(game_save_data_partial_double._last_save_time, 0.0)


func test_save_characteristics_success() -> void:
	# Arrange
	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(true)

	# Act
	var success := await sut._save_characteristics()

	# Assert
	assert_true(success)


func test_save_characteristics_failure() -> void:
	# Arrange
	stub(characteristics_api_partial_double, "update_game_save_characteristics").to_return(false)

	# Act
	var success := await sut._save_characteristics()

	# Assert
	assert_false(success)


func test_save_currencies_success() -> void:
	# Arrange
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(true)

	# Act
	var success := await sut._save_currencies()

	# Assert
	assert_true(success)


func test_save_currencies_failure() -> void:
	# Arrange
	stub(currencies_api_partial_double, "update_game_save_currencies").to_return(false)

	# Act
	var success := await sut._save_currencies()

	# Assert
	assert_false(success)


func test_save_inventory_fetch_failure() -> void:
	# Arrange
	stub(inventory_service_partial_double, "get_items").to_return([])
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(null)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_false(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 0)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 0)
	assert_call_count(inventory_api_partial_double, "delete_game_save_inventory_item", 0)


func test_save_inventory_with_items_to_delete() -> void:
	# Arrange
	var main_stat := ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	main_stat.base_value = 100

	var additional_stat := ItemStat.new()
	additional_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	additional_stat.base_value = 50

	var item1 := Item.new()
	item1.client_id = "item1"
	item1.base_id = "sword_normal_1"
	item1.main_stat = main_stat
	item1.additional_stats = [additional_stat]
	item1.rarity = ItemRarity.ItemRarity.NORMAL
	item1.level = 1
	item1.type = ItemType.ItemType.SWORD
	item1.is_equipped = false

	var items: Array[Item] = [item1]

	var item1_dict: Dictionary = {
		"client_id": "item1",
		"base_id": "sword_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var item2_dict: Dictionary = {
		"client_id": "item2",
		"base_id": "shield_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var fetch_inventory_dto: Dictionary = {"items": [item1_dict, item2_dict]}

	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new(fetch_inventory_dto)
	)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(true)
	stub(inventory_api_partial_double, "delete_game_save_inventory_item").to_return(true)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_true(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 1)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 0)
	assert_call_count(inventory_api_partial_double, "delete_game_save_inventory_item", 1)


func test_save_inventory_delete_failure() -> void:
	# Arrange
	var main_stat := ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	main_stat.base_value = 100

	var additional_stat := ItemStat.new()
	additional_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	additional_stat.base_value = 50

	var item1 := Item.new()
	item1.client_id = "item1"
	item1.base_id = "sword_normal_1"
	item1.main_stat = main_stat
	item1.additional_stats = [additional_stat]
	item1.rarity = ItemRarity.ItemRarity.NORMAL
	item1.level = 1
	item1.type = ItemType.ItemType.SWORD
	item1.is_equipped = false

	var items: Array[Item] = [item1]

	var item1_dict: Dictionary = {
		"client_id": "item1",
		"base_id": "sword_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var item2_dict: Dictionary = {
		"client_id": "item2",
		"base_id": "shield_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var fetch_inventory_dto: Dictionary = {"items": [item1_dict, item2_dict]}

	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new(fetch_inventory_dto)
	)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(true)
	stub(inventory_api_partial_double, "delete_game_save_inventory_item").to_return(false)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_false(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 1)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 0)
	assert_call_count(inventory_api_partial_double, "delete_game_save_inventory_item", 1)


func test_save_stage_success() -> void:
	# Arrange
	stub(stage_api_partial_double, "update_game_save_stage").to_return(true)

	# Act
	var success := await sut._save_stage()

	# Assert
	assert_true(success)


func test_save_stage_failure() -> void:
	# Arrange
	stub(stage_api_partial_double, "update_game_save_stage").to_return(false)

	# Act
	var success := await sut._save_stage()

	# Assert
	assert_false(success)


func test_save_inventory_create_failure() -> void:
	# Arrange
	var main_stat := ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	main_stat.base_value = 100

	var additional_stat := ItemStat.new()
	additional_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	additional_stat.base_value = 50

	var item1 := Item.new()
	item1.client_id = "item1"
	item1.base_id = "sword_normal_1"
	item1.main_stat = main_stat
	item1.additional_stats = [additional_stat]
	item1.rarity = ItemRarity.ItemRarity.NORMAL
	item1.level = 1
	item1.type = ItemType.ItemType.SWORD
	item1.is_equipped = false

	var items: Array[Item] = [item1]

	var fetch_inventory_dto: Dictionary = {"items": []}

	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new(fetch_inventory_dto)
	)
	stub(inventory_api_partial_double, "create_game_save_inventory_item").to_return(false)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_false(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 0)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 1)
	assert_call_count(inventory_api_partial_double, "delete_game_save_inventory_item", 0)


func test_save_inventory_update_failure() -> void:
	# Arrange
	var main_stat := ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	main_stat.base_value = 100

	var additional_stat := ItemStat.new()
	additional_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	additional_stat.base_value = 50

	var item1 := Item.new()
	item1.client_id = "item1"
	item1.base_id = "sword_normal_1"
	item1.main_stat = main_stat
	item1.additional_stats = [additional_stat]
	item1.rarity = ItemRarity.ItemRarity.NORMAL
	item1.level = 1
	item1.type = ItemType.ItemType.SWORD
	item1.is_equipped = false

	var items: Array[Item] = [item1]

	var item1_dict: Dictionary = {
		"client_id": "item1",
		"base_id": "sword_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var fetch_inventory_dto: Dictionary = {"items": [item1_dict]}

	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new(fetch_inventory_dto)
	)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(false)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_false(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 1)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 0)
	assert_call_count(inventory_api_partial_double, "delete_game_save_inventory_item", 0)


func test_save_inventory_success() -> void:
	# Arrange
	var main_stat := ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	main_stat.base_value = 100

	var additional_stat := ItemStat.new()
	additional_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	additional_stat.base_value = 50

	var item1 := Item.new()
	item1.client_id = "item1"
	item1.base_id = "sword_normal_1"
	item1.main_stat = main_stat
	item1.additional_stats = [additional_stat]
	item1.rarity = ItemRarity.ItemRarity.NORMAL
	item1.level = 1
	item1.type = ItemType.ItemType.SWORD
	item1.is_equipped = false

	var item2 := Item.new()
	item2.client_id = "item2"
	item2.base_id = "shield_normal_1"
	item2.main_stat = main_stat
	item2.additional_stats = [additional_stat]
	item2.rarity = ItemRarity.ItemRarity.NORMAL
	item2.level = 2
	item2.type = ItemType.ItemType.SHIELD
	item2.is_equipped = true

	var items: Array[Item] = [item1, item2]

	var item1_dict: Dictionary = {
		"client_id": "item1",
		"base_id": "sword_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var fetch_inventory_dto: Dictionary = {"items": [item1_dict]}

	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new(fetch_inventory_dto)
	)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(true)
	stub(inventory_api_partial_double, "create_game_save_inventory_item").to_return(true)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_true(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 1)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 1)


func test_save_inventory_partial_failure() -> void:
	# Arrange
	var main_stat := ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics.ATTACK_ADD
	main_stat.base_value = 100

	var additional_stat := ItemStat.new()
	additional_stat.statistic = ItemStatistics.ItemStatistics.HEALTH_ADD
	additional_stat.base_value = 50

	var item1 := Item.new()
	item1.client_id = "item1"
	item1.base_id = "sword_normal_1"
	item1.main_stat = main_stat
	item1.additional_stats = [additional_stat]
	item1.rarity = ItemRarity.ItemRarity.NORMAL
	item1.level = 1
	item1.type = ItemType.ItemType.SWORD
	item1.is_equipped = false

	var item2 := Item.new()
	item2.client_id = "item2"
	item2.base_id = "shield_normal_1"
	item2.main_stat = main_stat
	item2.additional_stats = [additional_stat]
	item2.rarity = ItemRarity.ItemRarity.NORMAL
	item2.level = 2
	item2.type = ItemType.ItemType.SHIELD
	item2.is_equipped = true

	var items: Array[Item] = [item1, item2]

	var item1_dict: Dictionary = {
		"client_id": "item1",
		"base_id": "sword_normal_1",
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats":
		[
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[additional_stat.statistic],
				"base_value": additional_stat.base_value
			}
		],
		"rarity": ItemRarity.ItemRarity.keys()[item1.rarity],
		"level": 1,
		"type": ItemType.ItemType.keys()[item1.type],
		"is_equipped": false
	}

	var fetch_inventory_dto: Dictionary = {"items": [item1_dict]}

	stub(inventory_service_partial_double, "get_items").to_return(items)
	stub(inventory_api_partial_double, "fetch_game_save_inventory").to_return(
		FetchInventoryDto.new(fetch_inventory_dto)
	)
	stub(inventory_api_partial_double, "update_game_save_inventory_item").to_return(false)
	stub(inventory_api_partial_double, "create_game_save_inventory_item").to_return(false)

	# Act
	var result := await sut._save_inventory()

	# Assert
	assert_false(result)
	assert_call_count(inventory_api_partial_double, "update_game_save_inventory_item", 1)
	assert_call_count(inventory_api_partial_double, "create_game_save_inventory_item", 1)
