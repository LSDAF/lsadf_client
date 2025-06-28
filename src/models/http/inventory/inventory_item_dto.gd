class_name InventoryItemDto

var client_id: String
var base_id: String
var main_stat: ItemStat
var additional_stats: Array[ItemStat]
var rarity: ItemRarity.ItemRarity
var level: int
var type: ItemType.ItemType
var is_equipped: bool = false


func _init(dictionary: Dictionary) -> void:
	client_id = dictionary["client_id"]
	base_id = dictionary["base_id"]
	main_stat = ItemStat.new()
	main_stat.statistic = ItemStatistics.ItemStatistics[dictionary["main_stat"]["statistic"]]
	main_stat.base_value = dictionary["main_stat"]["base_value"]

	for additional_stat: Dictionary in dictionary["additional_stats"]:
		additional_stats.push_back(ItemStat.new())
		additional_stats.back().statistic = (
			ItemStatistics.ItemStatistics[additional_stat["statistic"]]
		)
		additional_stats.back().base_value = additional_stat["base_value"]

	rarity = ItemRarity.ItemRarity[dictionary["rarity"]]
	level = dictionary["level"]
	type = ItemType.ItemType[dictionary["type"]]
	is_equipped = dictionary["is_equipped"]


func to_dictionary() -> Dictionary:
	var additional_stats_array: Array = []
	for stat in additional_stats:
		additional_stats_array.push_back(
			{
				"statistic": ItemStatistics.ItemStatistics.keys()[stat.statistic],
				"base_value": stat.base_value
			}
		)

	return {
		"client_id": client_id,
		"base_id": base_id,
		"main_stat":
		{
			"statistic": ItemStatistics.ItemStatistics.keys()[main_stat.statistic],
			"base_value": main_stat.base_value
		},
		"additional_stats": additional_stats_array,
		"rarity": ItemRarity.ItemRarity.keys()[rarity],
		"level": level,
		"type": ItemType.ItemType.keys()[type],
		"is_equipped": is_equipped
	}
