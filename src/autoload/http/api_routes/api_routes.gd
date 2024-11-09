class_name ApiRoutes
extends Node

const APP_PORT: String = "8080"
const APP_URL: String = "http://localhost:" + APP_PORT

# Public routes
const LOGIN := APP_URL + "/api/v1/auth/login"
const REFRESH_LOGIN := APP_URL + "/api/v1/auth/refresh"
const REGISTER := APP_URL + "/api/v1/auth/register"

# Private routes
const FETCH_GAME_SAVES := APP_URL + "/api/v1/game_save/me"
const FETCH_GAME_SAVES_STAGE := APP_URL + "/api/v1/stage/{game_save_id}"
const FETCH_GAME_SAVES_CHARACTERISTICS := APP_URL + "/api/v1/characteristics/{game_save_id}"
const FETCH_GAME_SAVES_CURRENCIES := APP_URL + "/api/v1/currency/{game_save_id}"
const GENERATE_GAME_SAVE := APP_URL + "/api/v1/game_save/generate"
const UPDATE_GAME_SAVE_CHARACTERISTICS := APP_URL + "/api/v1/characteristics/{game_save_id}"
const UPDATE_GAME_SAVE_CURRENCIES := APP_URL + "/api/v1/currency/{game_save_id}"
const UPDATE_GAME_SAVE_STAGE := APP_URL + "/api/v1/stage/{game_save_id}"
const UPDATE_GAME_SAVE_NICKNAME := APP_URL + "/api/v1/game_save/{game_save_id}/nickname"
