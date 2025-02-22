class_name AffixPool
extends Resource

@export var prefixes: Array[ItemAffix]
@export var suffixes: Array[ItemAffix]


func _init() -> void:
	prefixes = []
	suffixes = []


func add_affix(affix: ItemAffix) -> void:
	match affix.affix_type:
		AffixType.AffixType.PREFIX:
			prefixes.append(affix)
		AffixType.AffixType.SUFFIX:
			suffixes.append(affix)


func get_available_affixes(
	affix_type: AffixType.AffixType, item_type: ItemType.ItemType
) -> Array[ItemAffix]:
	var pool: Array[ItemAffix] = prefixes if affix_type == AffixType.AffixType.PREFIX else suffixes
	return pool.filter(
		func(affix: ItemAffix) -> bool: return affix.can_roll_on_item_type(item_type)
	)


func get_available_affixes_by_role(
	affix_type: AffixType.AffixType, item_type: ItemType.ItemType, role: AffixType.AffixRole
) -> Array[ItemAffix]:
	var available := get_available_affixes(affix_type, item_type)
	return available.filter(func(affix: ItemAffix) -> bool: return affix.affix_role == role)


func to_dictionary() -> Dictionary:
	return {
		"prefixes":
		prefixes.map(func(affix: ItemAffix) -> Dictionary: return affix.to_dictionary()),
		"suffixes": suffixes.map(func(affix: ItemAffix) -> Dictionary: return affix.to_dictionary())
	}


static func from_dictionary(dict: Dictionary) -> AffixPool:
	var pool := AffixPool.new()

	for prefix_dict: Dictionary in dict["prefixes"]:
		pool.prefixes.append(ItemAffix.from_dictionary(prefix_dict))

	for suffix_dict: Dictionary in dict["suffixes"]:
		pool.suffixes.append(ItemAffix.from_dictionary(suffix_dict))

	return pool
