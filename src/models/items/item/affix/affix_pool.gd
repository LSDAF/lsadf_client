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


func get_available_prefixes(item_type: ItemType.ItemType) -> Array[ItemAffix]:
	return prefixes.filter(
		func(affix: ItemAffix) -> bool: return affix.can_roll_on_item_type(item_type)
	)


func get_available_suffixes(item_type: ItemType.ItemType) -> Array[ItemAffix]:
	return suffixes.filter(
		func(affix: ItemAffix) -> bool: return affix.can_roll_on_item_type(item_type)
	)


func get_available_prefixes_by_role(
	item_type: ItemType.ItemType, role: AffixType.AffixRole
) -> Array[ItemAffix]:
	var available := get_available_prefixes(item_type)
	return available.filter(func(affix: ItemAffix) -> bool: return affix.affix_role == role)


func get_available_suffixes_by_role(
	item_type: ItemType.ItemType, role: AffixType.AffixRole
) -> Array[ItemAffix]:
	var available := get_available_suffixes(item_type)
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
