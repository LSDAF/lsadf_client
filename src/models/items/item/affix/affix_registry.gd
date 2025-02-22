class_name AffixRegistry
extends Resource

## This class contains all possible affixes that can be generated on items
## Each affix is defined with its base properties and allowed item types

const AFFIX_PATHS := {
	"offensive": "res://src/resources/affixes/offensive",
	"defensive": "res://src/resources/affixes/defensive",
	"utility": "res://src/resources/affixes/utility",
	"mobility": "res://src/resources/affixes/mobility"
}

var _affixes: Array[ItemAffix] = []


func _init() -> void:
	_load_all_affixes()


func _load_all_affixes() -> void:
	for category in AFFIX_PATHS:
		var dir := DirAccess.open(AFFIX_PATHS[category])
		if dir:
			dir.list_dir_begin()
			var file_name := dir.get_next()

			while file_name != "":
				if file_name.ends_with(".tres"):
					var affix := load(AFFIX_PATHS[category].path_join(file_name)) as ItemAffix
					if affix:
						_affixes.append(affix)
				file_name = dir.get_next()


## Returns all registered affixes
func get_all_affixes() -> Array[ItemAffix]:
	return _affixes


## Returns all affixes that can roll on the given item type
func get_affixes_for_item_type(item_type: ItemType.ItemType) -> Array[ItemAffix]:
	return _affixes.filter(func(affix): return affix.can_roll_on_item_type(item_type))


## Returns all prefix affixes that can roll on the given item type
func get_prefixes_for_item_type(item_type: ItemType.ItemType) -> Array[ItemAffix]:
	return _affixes.filter(
		func(affix):
			return (
				affix.can_roll_on_item_type(item_type)
				and affix.affix_type == AffixType.AffixType.PREFIX
			)
	)


## Returns all suffix affixes that can roll on the given item type
func get_suffixes_for_item_type(item_type: ItemType.ItemType) -> Array[ItemAffix]:
	return _affixes.filter(
		func(affix):
			return (
				affix.can_roll_on_item_type(item_type)
				and affix.affix_type == AffixType.AffixType.SUFFIX
			)
	)


## Returns all affixes of a specific role that can roll on the given item type
func get_affixes_by_role(
	item_type: ItemType.ItemType, role: AffixType.AffixRole
) -> Array[ItemAffix]:
	return _affixes.filter(
		func(affix): return affix.can_roll_on_item_type(item_type) and affix.affix_role == role
	)
