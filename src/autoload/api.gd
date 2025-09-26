extends Node

var auth: AuthApi = preload("res://src/http/auth/auth_api.gd").new()
var characteristics: CharacteristicsApi = (
	preload("res://src/http/characteristics/characteristics_api.gd").new()
)
var currencies: CurrenciesApi = preload("res://src/http/currencies/currencies_api.gd").new()
var game_save: GameSaveApi = preload("res://src/http/game_save/game_save_api.gd").new()
var inventory: InventoryApi = preload("res://src/http/inventory/inventory_api.gd").new()
var stage: StageApi = preload("res://src/http/stage/stage_api.gd").new()
var user: UserApi = preload("res://src/http/user/user_api.gd").new()
var game_session: GameSessionApi = preload("res://src/http/game_session/game_session_api.gd").new()
