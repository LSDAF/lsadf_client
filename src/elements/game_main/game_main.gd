class_name GameMain
extends Node

signal on_logout

var _lambda := func() -> bool:
	var result := await Services.game_save.save_game()
	return result


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Hud.on_logout.connect(_on_logout)


func _on_logout() -> void:
	on_logout.emit()


func _on_game_save_timer_timeout() -> void:
	#	Services.game_save.save_game()
	var http_event: HttpEvent = HttpEvent.new(
		{"function": _lambda, "nb_tries": 1, "prioritary": true}
	)
	Services.http_event_handler.enqueue_event(http_event)
	await Services.http_event_handler.process_queue(true)
