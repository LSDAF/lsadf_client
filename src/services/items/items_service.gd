# gdlint: disable = max-returns

class_name ItemsService

# INFO: Since this class is static, it is not possible to use
# exports for resources since we have no attached scene
var item_stats_pools: ItemStatsPools = preload(
	"res://src/resources/items/stats/pools/item_stats_pools.tres"
)
var item_pools: ItemPools = preload("res://src/resources/items/item_pools/item_pools.tres")

var _game_save_service: GameSaveService


func _init(
	game_save_service: GameSaveService,
) -> void:
	_game_save_service = game_save_service


func create_item(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> Item:
	var item := Item.new()

	# Fixed
	item.level = 1

	# From constructor
	item.client_id = _game_save_service.get_game_save_id() + "__" + Tools.uuid.v4()
	item.type = item_type
	item.rarity = item_rarity

	# Depend on constructor
	var item_stats_pool := _get_stats_pool_from_pools(item_type, item_rarity)
	item.main_stat = _get_main_stat(item_stats_pool)
	item.additional_stats = _get_additionnal_stats(item_stats_pool)

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
				return item_pools.swords.normal[0]
			return pool.normal.pick_random()
		ItemRarity.ItemRarity.COMMON:
			if pool.common.is_empty():
				push_error("No common items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0]
			return pool.common.pick_random()
		ItemRarity.ItemRarity.UNCOMMON:
			if pool.uncommon.is_empty():
				push_error("No uncommon items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0]
			return pool.uncommon.pick_random()
		ItemRarity.ItemRarity.MAGIC:
			if pool.rare.is_empty():
				push_error("No magic items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0]
			return pool.magic.pick_random()
		ItemRarity.ItemRarity.RARE:
			if pool.rare.is_empty():
				push_error("No rare items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0]
			return pool.rare.pick_random()
		ItemRarity.ItemRarity.LEGENDARY:
			if pool.legendary.is_empty():
				push_error("No legendary items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0]
			return pool.legendary.pick_random()
		ItemRarity.ItemRarity.UNIQUE:
			if pool.unique.is_empty():
				push_error("No unique items in pool for type: %s" % item_type)
				return item_pools.swords.normal[0]
			return pool.unique.pick_random()
		_:
			push_error("Unknown rarity: %s" % item_rarity)
			return item_pools.swords.normal[0]


func _get_stats_pool_from_pools(
	item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity
) -> ItemStatsPool:
	match item_type:
		ItemType.ItemType.BOOTS:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.boots.normal
		ItemType.ItemType.CHESTPLATE:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.chestplates.normal
		ItemType.ItemType.GLOVES:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.gloves.normal
		ItemType.ItemType.HELMET:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.helmets.normal
		ItemType.ItemType.SHIELD:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.shields.normal
		ItemType.ItemType.SWORD:
			match item_rarity:
				ItemRarity.ItemRarity.NORMAL:
					return item_stats_pools.swords.normal

	# WIP
	return item_stats_pools.swords.normal


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
