class_name TimerService

extends Node


# works because TimerService has been added as Service child in autoload/services.gd
func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
