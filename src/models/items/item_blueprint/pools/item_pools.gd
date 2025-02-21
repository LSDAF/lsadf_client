class_name ItemPools
extends Resource

@export var boots: ItemPool
@export var chestplates: ItemPool
@export var gloves: ItemPool
@export var helmets: ItemPool
@export var shields: ItemPool
@export var swords: ItemPool


func get_blueprint_from_id(blueprint_id: String) -> ItemBlueprint:
	# Get all item pools
	var pools := [boots, chestplates, gloves, helmets, shields, swords]

	# Check all rarity pools for each item type
	for pool: ItemPool in pools:
		# List of all rarity pools to check
		var rarity_pools: Array[Array] = [
			pool.normal,
			pool.common,
			pool.uncommon,
			pool.magic,
			pool.rare,
			pool.legendary,
			pool.unique,
		]

		# Check each rarity pool
		for rarity_pool: Array[ItemBlueprint] in rarity_pools:
			for blueprint: ItemBlueprint in rarity_pool:
				if blueprint.id == blueprint_id:
					return blueprint

	return null
