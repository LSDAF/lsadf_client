class_name UpdateCurrenciesDto

var gold: int
var diamond: int
var emerald: int
var amethyst: int


func _init(gold: int, diamond: int, emerald: int, amethyst: int) -> void:
	gold = gold
	diamond = diamond
	emerald = emerald
	amethyst = amethyst


func to_dictionary() -> Dictionary:
	return {
		"gold": gold,
		"diamonds": diamond,
		"emeralds": emerald,
		"amethysts": amethyst,
	}
