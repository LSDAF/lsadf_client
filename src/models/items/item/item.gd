class_name Item

var client_id: String
var blueprint_id: String
var main_stat: ItemStat
var additional_stats: Array[ItemStat]
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

	if main_stat.statistic == item_statistic:
		total_value += main_stat.base_value * level

	var corresponding_additional_stats: Array[ItemStat] = additional_stats.filter(
		func(additional_stat: ItemStat) -> bool: return additional_stat.statistic == item_statistic
	)
	for additional_stat in corresponding_additional_stats:
		total_value += additional_stat.base_value * level

	return total_value
