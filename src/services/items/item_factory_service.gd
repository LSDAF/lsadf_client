class_name ItemFactoryService

# Dependencies
var _affixes_service: AffixesService
var _game_save_service: GameSaveService
var _blueprint_service: BlueprintService

# Resources
var rarity_specs: RaritySpecs = preload("res://src/resources/items/rarity_specs/rarity_specs.tres")


func _init(
	affixes_service: AffixesService,
	game_save_service: GameSaveService,
	blueprint_service: BlueprintService
) -> void:
	_affixes_service = affixes_service
	_game_save_service = game_save_service
	_blueprint_service = blueprint_service


func create_item(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> Item:
	# Get the item blueprint first, as it contains the implicit affix
	var item_blueprint: ItemBlueprint = _blueprint_service.get_random_blueprint(item_type, item_rarity)
	var item := Item.new()

	# Fixed properties
	item.level = 1

	# From constructor
	item.client_id = _game_save_service.get_game_save_id() + "__" + Tools.uuid.v4()
	item.type = item_type
	item.rarity = item_rarity

	# Set blueprint-derived properties
	item.name = item_blueprint.name
	item.texture = item_blueprint.texture
	item.blueprint_id = item_blueprint.id
	
	# Assign implicit affix from blueprint
	if item_blueprint.implicit_affix:
		# Create a new instance with the same properties
		item.implicit_affix = _affixes_service.create_affix_instance(item_blueprint.implicit_affix)
	else:
		# No fallback - blueprint must have an implicit affix
		push_error("Blueprint %s missing required implicit affix" % item_blueprint.id)
		return null
	
	# Generate affixes
	var rarity_spec := rarity_specs.get_rarity_spec(item_rarity)
	var affix_counts := _get_affix_counts(rarity_spec)

	# Generate prefixes
	for i in range(affix_counts.prefix_count):
		var prefix := _affixes_service.create_random_affix(true, item_type)
		if prefix == null:
			break
		item.prefixes.append(prefix)

	# Generate suffixes
	for i in range(affix_counts.suffix_count):
		var suffix := _affixes_service.create_random_affix(false, item_type)
		if suffix == null:
			break
		item.suffixes.append(suffix)

	return item



# Determines how many prefixes and suffixes an item should have based on its rarity
func _get_affix_counts(rarity_spec: RaritySpec) -> Dictionary:
	var prefix_count := 0
	var suffix_count := 0

	# Roll for prefixes
	for _i in range(rarity_spec.max_prefix_count):
		if randf() <= rarity_spec.prefix_chance:
			prefix_count += 1

	# Roll for suffixes
	for _i in range(rarity_spec.max_suffix_count):
		if randf() <= rarity_spec.suffix_chance:
			suffix_count += 1

	return {
		"prefix_count": prefix_count,
		"suffix_count": suffix_count
	}
