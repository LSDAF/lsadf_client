extends Node

# Scripts
var affixes: AffixesData = preload("res://src/data/affixes/affixes_data.gd").new()
var characteristics: CharacteristicsData = (
	preload("res://src/data/characteristics/characteristics_data.gd").new()
)
var currencies: CurrenciesData = preload("res://src/data/currencies/currencies_data.gd").new()
var current_quest: CurrentQuestData = (
	preload("res://src/data/current_quest/current_quest_data.gd").new()
)
var difficulty: DifficultyData = preload("res://src/data/difficulty/difficulty_data.gd").new()
var game_save: GameSaveData = preload("res://src/data/game_save/game_save_data.gd").new()
var inventory: InventoryData = preload("res://src/data/inventory/inventory_data.gd").new()
var item_bases: ItemBasesData = preload("res://src/data/items/item_bases_data.gd").new()
var user_local_data: UserLocalData = preload("res://src/data/user_local/user_local_data.gd").new()
var stage: StageData = preload("res://src/data/stage/stage_data.gd").new()


func _ready() -> void:
	add_child(characteristics)
	add_child(current_quest)
