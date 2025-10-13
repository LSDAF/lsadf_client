class_name CurrenciesService

var _currency_data: CurrenciesData


func _init(currency_data: CurrenciesData) -> void:
	_currency_data = currency_data


# INFO: This function is only used for loading the game save
func _set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	_currency_data.gold._value = _gold
	_currency_data.diamond._value = _diamond
	_currency_data.emerald._value = _emerald
	_currency_data.amethyst._value = _amethyst


func get_gold_value() -> int:
	return _currency_data.gold.get_value()


func update_gold_value(delta: int) -> void:
	_currency_data.gold.update_value(delta)


func connect_gold_updated(callback: Callable) -> void:
	_currency_data.gold.updated.connect(callback)


func get_diamond_value() -> int:
	return _currency_data.diamond.get_value()


func connect_diamond_updated(callback: Callable) -> void:
	_currency_data.diamond.updated.connect(callback)


func get_amethyst_value() -> int:
	return _currency_data.amethyst.get_value()


func get_emerald_value() -> int:
	return _currency_data.emerald.get_value()


func connect_emerald_updated(callback: Callable) -> void:
	_currency_data.emerald.updated.connect(callback)


func connect_amethyst_updated(callback: Callable) -> void:
	_currency_data.amethyst.updated.connect(callback)


func update_amethyst_value(delta: int) -> void:
	_currency_data.amethyst.update_value(delta)
