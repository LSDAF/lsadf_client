class_name AffixesService

# Import the data classes we need
const AffixesDataScript := preload("res://src/data/affixes/affixes_data.gd")
const AffixRegistryScript := preload("res://src/models/items/item/affix/affix_registry.gd")

var _affixes_data: AffixesDataScript

func _init(affixes_data: AffixesDataScript) -> void:
	_affixes_data = affixes_data

func get_all_prefixes() -> Array[ItemAffix]:
	var registry: AffixRegistryScript = _affixes_data.registry as AffixRegistryScript
	return registry.affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.affix_type == AffixType.AffixType.PREFIX
	)
	
func get_all_suffixes() -> Array[ItemAffix]:
	var registry: AffixRegistryScript = _affixes_data.registry as AffixRegistryScript
	return registry.affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.affix_type == AffixType.AffixType.SUFFIX
	)


# Creates a new instance of an affix with the same properties
func create_affix_instance(source_affix: ItemAffix) -> ItemAffix:
	return ItemAffix.new(
		source_affix.statistic,
		source_affix.base_value,
		source_affix.affix_type,
		source_affix.affix_role,
		source_affix.scaling_type,
		source_affix.allowed_item_types
	)


# Creates an ItemAffix based on the given parameters
# The affix will be randomly selected from the available pool based on type and item type
func create_random_affix(is_prefix: bool, item_type: ItemType.ItemType) -> ItemAffix:
	# Get available affixes based on type
	var available_affixes: Array[ItemAffix] = (
		get_all_prefixes()
		if is_prefix
		else get_all_suffixes()
	)
	
	# Filter by item type
	available_affixes = available_affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.can_roll_on_item_type(item_type)
	)

	# Pick a random affix from the pool
	if available_affixes.is_empty():
		push_error(
			"No available affixes found for prefix: %s and item type %s" % [is_prefix, item_type]
		)
		return null

	var chosen_affix := available_affixes[randi() % available_affixes.size()]

	# Create a new instance with the same properties
	return create_affix_instance(chosen_affix)
