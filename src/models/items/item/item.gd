class_name Item

var client_id: String
var base_id: String
var implicit_affix: ItemAffix
var prefixes: Array[ItemAffix] = []
var suffixes: Array[ItemAffix] = []
var rarity: ItemRarity.ItemRarity
var level: int
var type: ItemType.ItemType
var name: String
var texture: Texture2D
var is_equipped: bool = false


func level_up_cost() -> int:
	return pow(level, 1.25)


func item_salvage_price() -> int:
	return pow(level, 1.5)


func total_stat_value(item_statistic: ItemStatistics.ItemStatistics) -> float:
	var total_value := 0.0

	# Check implicit affix
	if implicit_affix and implicit_affix.statistic == item_statistic:
		total_value += implicit_affix.calculate_value(level)

	# Check prefixes
	for prefix in prefixes:
		if prefix.statistic == item_statistic:
			total_value += prefix.calculate_value(level)
	
	# Check suffixes
	for suffix in suffixes:
		if suffix.statistic == item_statistic:
			total_value += suffix.calculate_value(level)

	return total_value
