class_name GameMain
extends Node

signal on_logout

var _lambda := func() -> void: Services.game_save.save_game()
var _game_session_renewal := func() -> void: Services.game_session.refresh_game_session()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Hud.on_logout.connect(_on_logout)


func _on_logout() -> void:
	on_logout.emit()


func _on_game_save_timer_timeout() -> void:
	#	Services.game_save.save_game()
	var http_request: HttpEvent = HttpEvent.new(
		{"function": _lambda, "nb_tries": 1, "prioritary": true}
	)
	Services.http_event_handler.enqueue_event(http_request)
	Services.http_event_handler.process_queue(false)
	Services.http_event_handler.process_queue(true)


func _on_game_session_timer_timeout() -> void:
	#	Services.game_session.renew_session()
	print_debug("Running game session renewal...")
	var http_request: HttpEvent = HttpEvent.new(
		{"function": _game_session_renewal, "nb_tries": 1, "prioritary": false}
	)
	Services.http_event_handler.enqueue_event(http_request)
	Services.http_event_handler.process_queue(false)
	Services.http_event_handler.process_queue(true)
	print_debug("Game session renewed.")
