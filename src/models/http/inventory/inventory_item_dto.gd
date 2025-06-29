class_name InventoryItemDto

var client_id: String
var base_id: String
var implicit_affix_base_value: float
var prefixes: Array[ItemAffixDTO]
var suffixes: Array[ItemAffixDTO]
var rarity: ItemRarity.ItemRarity
var level: int
var type: ItemType.ItemType
var is_equipped: bool = false


func _init(dictionary: Dictionary) -> void:
	client_id = dictionary["client_id"]
	base_id = dictionary["base_id"]
	implicit_affix_base_value = dictionary["implicit_affix_base_value"]
	
	prefixes = []
	for prefix: Dictionary in dictionary["prefixes"]:
		prefixes.push_back(ItemAffixDTO.new(prefix))
	
	suffixes = []
	for suffix: Dictionary in dictionary["suffixes"]:
		suffixes.push_back(ItemAffixDTO.new(suffix))

	rarity = ItemRarity.ItemRarity[dictionary["rarity"]]
	level = dictionary["level"]
	type = ItemType.ItemType[dictionary["type"]]
	is_equipped = dictionary["is_equipped"]


func to_dictionary() -> Dictionary:
	return {
		"client_id": client_id,
		"base_id": base_id,
		"implicit_affix_base_value": implicit_affix_base_value,
		"prefixes": prefixes.map(func(prefix: ItemAffixDTO) -> Dictionary: return prefix.to_dictionary()),
		"suffixes": suffixes.map(func(suffix: ItemAffixDTO) -> Dictionary: return suffix.to_dictionary()),
		"rarity": ItemRarity.ItemRarity.keys()[rarity],
		"level": level,
		"type": ItemType.ItemType.keys()[type],
		"is_equipped": is_equipped
	}
