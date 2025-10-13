extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Services.currencies.connect_amethyst_updated(_update_amethyst_value)
	_update_amethyst_value(Services.currencies.get_amethyst_value())


func _update_amethyst_value(new_value: int) -> void:
	text = str(new_value)
