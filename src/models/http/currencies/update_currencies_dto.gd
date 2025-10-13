class_name UpdateCurrenciesDto

var gold: int
var diamond: int
var emerald: int
var amethyst: int


func _init(gold_value: int, diamond_value: int, emerald_value: int, amethyst_value: int) -> void:
	gold = gold_value
	diamond = diamond_value
	emerald = emerald_value
	amethyst = amethyst_value


func to_dictionary() -> Dictionary:
	return {
		"gold": gold,
		"diamonds": diamond,
		"emeralds": emerald,
		"amethysts": amethyst,
	}
