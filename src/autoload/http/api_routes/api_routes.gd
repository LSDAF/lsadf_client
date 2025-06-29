class_name ApiRoutes
extends Node

var APP_URL := Config.config.server_url

# Public routes
var LOGIN := APP_URL + "/api/v1/auth/login"
var REFRESH_LOGIN := APP_URL + "/api/v1/auth/refresh"
var REGISTER := APP_URL + "/api/v1/auth/register"

# Private routes
var FETCH_GAME_SAVES := APP_URL + "/api/v1/game_save/me"
var FETCH_GAME_SAVES_STAGE := APP_URL + "/api/v1/stage/{game_save_id}"
var FETCH_GAME_SAVES_CHARACTERISTICS := APP_URL + "/api/v1/characteristics/{game_save_id}"
var FETCH_GAME_SAVES_CURRENCIES := APP_URL + "/api/v1/currency/{game_save_id}"
var FETCH_GAME_SAVES_INVENTORY := APP_URL + "/api/v1/inventory/{game_save_id}"
var UPDATE_GAME_SAVE_INVENTORY_ITEM := (
	APP_URL + "/api/v1/inventory/{game_save_id}/items/{client_id}"
)
var CREATE_GAME_SAVE_INVENTORY_ITEM := APP_URL + "/api/v1/inventory/{game_save_id}/items"
var DELETE_GAME_SAVE_INVENTORY_ITEM := (
	APP_URL + "/api/v1/inventory/{game_save_id}/items/{client_id}"
)
var GENERATE_GAME_SAVE := APP_URL + "/api/v1/game_save/generate"
var UPDATE_GAME_SAVE_CHARACTERISTICS := APP_URL + "/api/v1/characteristics/{game_save_id}"
var UPDATE_GAME_SAVE_CURRENCIES := APP_URL + "/api/v1/currency/{game_save_id}"
var UPDATE_GAME_SAVE_STAGE := APP_URL + "/api/v1/stage/{game_save_id}"
var UPDATE_GAME_SAVE_NICKNAME := APP_URL + "/api/v1/game_save/{game_save_id}/nickname"
