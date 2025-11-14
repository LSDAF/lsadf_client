class_name UpdateCurrenciesDto

var gold: int
var diamond: int
var emerald: int
var amethyst: int


func _init(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	gold = _gold
	diamond = _diamond
	emerald = _emerald
	amethyst = _amethyst


func to_dictionary() -> Dictionary:
	return {
		"gold": gold,
		"diamonds": diamond,
		"emeralds": emerald,
		"amethysts": amethyst,
	}
