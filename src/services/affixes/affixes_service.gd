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
