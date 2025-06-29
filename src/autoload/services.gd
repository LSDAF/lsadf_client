extends Node

var clock: ClockService = preload("res://src/services/clock/clock_service.gd").new()

var characteristics: CharacteristicsService = (
	preload("res://src/services/characteristics/characteristics_service.gd")
	. new(Data.characteristics)
)

var currencies: CurrenciesService = (
	preload("res://src/services/currencies/currencies_service.gd").new(Data.currencies)
)

var current_quest: CurrentQuestService = (
	preload("res://src/services/current_quest/current_quest_service.gd")
	. new(Data.currencies, Data.current_quest)
)

var difficulty: DifficultyService = (
	preload("res://src/services/difficulty/difficulty_service.gd").new(Data.difficulty)
)

var stage: StageService = preload("res://src/services/stage/stage_service.gd").new(
	Data.stage, current_quest, difficulty
)

var item_bases: ItemBasesService = preload("res://src/services/items/item_bases_service.gd").new(
	Data.item_bases
)

var inventory: InventoryService = preload("res://src/services/inventory/inventory_service.gd").new(
	Data.inventory, item_bases, item_factory
)

var player_stats: PlayerStatsService = (
	preload("res://src/services/player_stats/player_stats_service.gd")
	. new(Data.characteristics, inventory)
)

var random_number_generator: RandomNumberGeneratorService = (
	preload("res://src/services/random_number_generator/random_number_generator_service.gd").new()
)

var resource_loader: ResourceLoaderService = (
	preload("res://src/services/resource_loader/resource_loader_service.gd").new()
)

var resource_saver: ResourceSaverService = (
	preload("res://src/services/resource_saver/resource_saver_service.gd").new()
)
var toaster: ToasterService = preload("res://src/services/toaster/toaster_service.gd").new()

var user_local_data: UserLocalDataService = (
	preload("res://src/services/user_local_data/user_local_data_service.gd")
	. new(Api.auth, Data.user_local_data, resource_loader, resource_saver)
)

var game_save: GameSaveService = preload("res://src/services/game_save/game_save_service.gd").new(
	Api.characteristics,
	Api.currencies,
	Api.inventory,
	Api.stage,
	clock,
	characteristics,
	currencies,
	inventory,
	stage,
	Data.game_save
)

var affixes: AffixesService = preload("res://src/services/affixes/affixes_service.gd").new(
	Data.affixes
)

var item_factory: ItemFactoryService = preload("res://src/services/items/item_factory_service.gd").new(
	affixes, item_bases, Data.game_save
)

var items: ItemsService = preload("res://src/services/items/items_service.gd").new(item_factory)

var loot: LootService = preload("res://src/services/loot/loot_service.gd").new(
	difficulty, inventory, items, random_number_generator
)

var http_event_handler: HttpEventHandler = (
	preload("res://src/services/http_event_handler/http_event_handler.gd")
	. new(Queue.new(), Queue.new())
)
