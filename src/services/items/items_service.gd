# gdlint: disable = max-returns

class_name ItemsService

# INFO: Since this class is static, it is not possible to use
# exports for resources since we have no attached scene
var item_stats_pools: ItemStatsPools = preload(
	"res://src/resources/items/stats/pools/item_stats_pools.tres"
)
var item_pools: ItemPools = preload("res://src/resources/items/item_pools/item_pools.tres")
var rarity_specs: RaritySpecs = preload("res://src/resources/items/rarity_specs/rarity_specs.tres")

var _game_save_service: GameSaveService
var _affixes_service: AffixesService


func _init(
	game_save_service: GameSaveService, affixes_service: AffixesService
) -> void:
	_game_save_service = game_save_service
	_affixes_service = affixes_service


func create_item(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> Item:
	var item := Item.new()

	# Fixed
	item.level = 1

	# From constructor
	item.client_id = _game_save_service.get_game_save_id() + "__" + Tools.uuid.v4()
	item.type = item_type
	item.rarity = item_rarity

	# Generate affixes
	var rarity_spec := rarity_specs.get_rarity_spec(item_rarity)
	var affix_counts := _get_affix_counts(rarity_spec)

	# Generate prefixes
	for i in range(affix_counts.prefix_count):
		var prefix := _create_affix(true, item_type, item_rarity)
		if prefix == null:
			break
		item.prefixes.append(prefix)

	# Generate suffixes
	for i in range(affix_counts.suffix_count):
		var suffix := _create_affix(false, item_type, item_rarity)
		if suffix == null:
			break
		item.suffixes.append(suffix)

	var item_blueprint: ItemBlueprint = _get_random_blueprint_from_pools(item_type, item_rarity)
	item.name = item_blueprint.name
	item.texture = item_blueprint.texture
	item.blueprint_id = item_blueprint.id

	return item


# INFO: This is a temporary solution during dev, do not test it
func create_random_item() -> Item:
	var item_type: ItemType.ItemType = ItemType.ItemType.values().pick_random()
	var item_rarity: ItemRarity.ItemRarity = ItemRarity.ItemRarity.values().pick_random()

	return create_item(item_type, item_rarity)


func _get_additionnal_stats(item_stats_pool: ItemStatsPool) -> Array[ItemStat]:
	var item_additionnal_stats_blueprints: Array[ItemStatBlueprint] = []
	var potential_stats_blueprints := item_stats_pool.potential_stats
	potential_stats_blueprints.shuffle()
	item_additionnal_stats_blueprints = potential_stats_blueprints.slice(0, 4)

	var item_additionnal_stats: Array[ItemStat] = []
	for item_additionnal_stats_blueprint in item_additionnal_stats_blueprints:
		var item_additionnal_stat: ItemStat = _roll_stat_value(item_additionnal_stats_blueprint)

		item_additionnal_stats.push_back(item_additionnal_stat)

	return item_additionnal_stats


func _get_main_stat(item_stats_pool: ItemStatsPool) -> ItemStat:
	return _roll_stat_value(item_stats_pool.main_stat)


func _get_random_blueprint_from_pools(
	item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity
) -> ItemBlueprint:
	var pool: ItemPool
	match item_type:
		ItemType.ItemType.BOOTS:
			pool = item_pools.boots
		ItemType.ItemType.CHESTPLATE:
			pool = item_pools.chestplates
		ItemType.ItemType.GLOVES:
			pool = item_pools.gloves
		ItemType.ItemType.HELMET:
			pool = item_pools.helmets
		ItemType.ItemType.SHIELD:
			pool = item_pools.shields
		ItemType.ItemType.SWORD:
			pool = item_pools.swords
		_:
			push_error("Unknown item type: %s" % item_type)
			return item_pools.swords.normal[0]

	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			if pool.normal.is_empty():
				push_error("No normal items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.normal.pick_random() as ItemBlueprint
		ItemRarity.ItemRarity.COMMON:
			if pool.common.is_empty():
				push_error("No common items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.common.pick_random() as ItemBlueprint
		ItemRarity.ItemRarity.UNCOMMON:
			if pool.uncommon.is_empty():
				push_error("No uncommon items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.uncommon.pick_random() as ItemBlueprint
		ItemRarity.ItemRarity.MAGIC:
			if pool.magic.is_empty():
				push_error("No magic items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.magic.pick_random() as ItemBlueprint
		ItemRarity.ItemRarity.RARE:
			if pool.rare.is_empty():
				push_error("No rare items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.rare.pick_random() as ItemBlueprint
		ItemRarity.ItemRarity.LEGENDARY:
			if pool.legendary.is_empty():
				push_error("No legendary items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.legendary.pick_random() as ItemBlueprint
		ItemRarity.ItemRarity.UNIQUE:
			if pool.unique.is_empty():
				push_error("No unique items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0] as ItemBlueprint
			return pool.unique.pick_random() as ItemBlueprint
		_:
			push_error("Unknown rarity: %s" % item_rarity)
			return item_pools.swords.normal[0]

func _roll_stat_value(item_stat_blueprint: ItemStatBlueprint) -> ItemStat:
	var item_stat := ItemStat.new()

	item_stat.statistic = item_stat_blueprint.statistic

	var item_stat_base_value := 0.0

	# TODO: use random_number_generator_service and mock it in tests
	var base_value_dice_roll := randf()
	var base_value_range: float = (
		item_stat_blueprint.base_value_max - item_stat_blueprint.base_value_min
	)
	var base_value_num_step: float = base_value_range / item_stat_blueprint.base_value_step

	var base_value_rolled_steps := ceili(base_value_dice_roll * base_value_num_step)
	item_stat_base_value = (
		item_stat_blueprint.base_value_min
		+ base_value_rolled_steps * item_stat_blueprint.base_value_step
	)

	# Security, useless ?
	item_stat.base_value = clamp(
		item_stat_base_value, item_stat_blueprint.base_value_min, item_stat_blueprint.base_value_max
	)

	return item_stat


## Returns the number of prefixes and suffixes for an item based on its rarity spec
## The result ensures:
## 1. At least min_prefix_number prefixes
## 2. At least min_suffix_number suffixes
## 3. Remaining slots (if any) are randomly distributed
func _get_affix_counts(rarity_spec: RaritySpec) -> Dictionary:
	# Start with minimum requirements
	var prefix_count := rarity_spec.min_prefix_number
	var suffix_count := rarity_spec.min_suffix_number

	# Calculate remaining slots
	var remaining_slots := rarity_spec.total_affix_number - prefix_count - suffix_count

	# Randomly distribute remaining slots
	while remaining_slots > 0:
		if randi() % 2 == 0:
			prefix_count += 1
		else:
			suffix_count += 1
		remaining_slots -= 1

	return {"prefix_count": prefix_count, "suffix_count": suffix_count}


## Creates an ItemAffix based on the given parameters
## The affix will be randomly selected from the available pool based on type and rarity
func _create_affix(
	is_prefix: bool,
	item_type: ItemType.ItemType,
	item_rarity: ItemRarity.ItemRarity
) -> ItemAffix:
	# Get available affixes based on type
	var available_affixes: Array[ItemAffix] = (
		_affixes_service.get_all_prefixes()
		if is_prefix
		else _affixes_service.get_all_suffixes()
	)
	
	# Filter by item type
	available_affixes = available_affixes.filter(
		func(affix: ItemAffix) -> bool: return affix.can_roll_on_item_type(item_type)
	)

	# Pick a random affix from the pool
	if available_affixes.is_empty():
		push_error(
			"No available affixes found for type %s and rarity %s" % [item_type, item_rarity]
		)
		return null

	var chosen_affix := available_affixes[randi() % available_affixes.size()]

	# Create a new instance with the same properties
	var new_affix := ItemAffix.new(
		chosen_affix.statistic,
		chosen_affix.base_value,
		chosen_affix.affix_type,
		chosen_affix.affix_role,
		chosen_affix.scaling_type,
		chosen_affix.allowed_item_types
	)

	return new_affix
