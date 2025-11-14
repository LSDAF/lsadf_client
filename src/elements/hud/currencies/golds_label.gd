extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Services.currencies.connect_gold_updated(_update_gold_value)
	_update_gold_value(Services.currencies.get_gold_value())


func _update_gold_value(new_value: int) -> void:
	text = str(new_value)
