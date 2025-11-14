extends Label


func _ready() -> void:
	Services.currencies.connect_emerald_updated(_update_emerald_value)
	_update_emerald_value(Services.currencies.get_emerald_value())


func _update_emerald_value(new_value: int) -> void:
	text = str(new_value)
