class_name BlueprintService

# Resources
var item_pools: ItemPools = preload("res://src/resources/items/item_pools/item_pools.tres")

func _init() -> void:
	pass

# Gets a random blueprint from the appropriate item pool based on type and rarity
func get_random_blueprint(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> ItemBlueprint:
	var pool: ItemPool = _get_pool_for_item_type(item_type)
	var blueprints: Array[ItemBlueprint] = _get_blueprints_for_rarity(pool, item_rarity)
	
	if blueprints.is_empty():
		push_error("No blueprints found for type %s and rarity %s" % [item_type, item_rarity])
		return _get_fallback_blueprint()
		
	return blueprints[randi() % blueprints.size()]

# Get a specific blueprint by its ID
func get_blueprint_by_id(blueprint_id: String) -> ItemBlueprint:
	# Search through all pools and rarities
	for item_type: int in ItemType.ItemType.values():
		var pool := _get_pool_for_item_type(item_type)
		
		for rarity: int in ItemRarity.ItemRarity.values():
			var blueprints := _get_blueprints_for_rarity(pool, rarity)
			
			for blueprint in blueprints:
				if blueprint.id == blueprint_id:
					return blueprint
	
	push_error("Blueprint with id %s not found" % blueprint_id)
	return _get_fallback_blueprint()

# Helper to get the appropriate pool based on item type
func _get_pool_for_item_type(item_type: ItemType.ItemType) -> ItemPool:
	match item_type:
		ItemType.ItemType.BOOTS:
			return item_pools.boots
		ItemType.ItemType.CHESTPLATE:
			return item_pools.chestplates
		ItemType.ItemType.GLOVES:
			return item_pools.gloves
		ItemType.ItemType.HELMET:
			return item_pools.helmets
		ItemType.ItemType.SHIELD:
			return item_pools.shields
		ItemType.ItemType.SWORD:
			return item_pools.swords
		_:
			push_error("Unknown item type: %s" % item_type)
			return item_pools.swords  # Fallback

# Helper to get blueprints for a specific rarity
func _get_blueprints_for_rarity(pool: ItemPool, item_rarity: ItemRarity.ItemRarity) -> Array[ItemBlueprint]:
	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			return pool.normal
		ItemRarity.ItemRarity.MAGIC:
			return pool.magic
		ItemRarity.ItemRarity.RARE:
			return pool.rare
		ItemRarity.ItemRarity.LEGENDARY:
			return pool.legendary
		_:
			push_error("Unknown item rarity: %s" % item_rarity)
			return pool.normal  # Fallback

# Provides a last-resort fallback blueprint if nothing else works
func _get_fallback_blueprint() -> ItemBlueprint:
	return item_pools.swords.normal[0]  # Assumes at least this exists
