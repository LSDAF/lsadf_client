class_name AffixesService

# Import the data classes we need
var _affixes_data: AffixesData

func _init(affixes_data: AffixesData) -> void:
	_affixes_data = affixes_data

func get_all_prefixes() -> Array[ItemAffix]:
	var registry: AffixRegistry = _affixes_data.registry
	return registry.affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.affix_type == AffixEnums.AffixType.PREFIX
	)
	
func get_all_suffixes() -> Array[ItemAffix]:
	var registry: AffixRegistry = _affixes_data.registry
	return registry.affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.affix_type == AffixEnums.AffixType.SUFFIX
	)


func get_affix_by_identifier(affix_identifier: AffixEnums.AffixIdentifier) -> ItemAffix:
	var matches := _affixes_data.registry.affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.identifier == affix_identifier
	)
	return matches[0] if matches.size() > 0 else null

# Creates a new instance of an affix with the same properties
func create_affix(affix_identifier: AffixEnums.AffixIdentifier, base_value: float) -> ItemAffix:
	var source_affix := get_affix_by_identifier(affix_identifier)
	
	return ItemAffix.new(
		source_affix.identifier,
		source_affix.statistic,
		base_value,
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
	return create_affix(chosen_affix.identifier, 0.0)
