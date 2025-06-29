class_name ItemFactoryService

# Dependencies
var _affixes_service: AffixesService
var _item_bases_service: ItemBasesService
var _game_save_data: GameSaveData

# Resources
var rarity_specs: RaritySpecs = preload("res://src/resources/items/rarity_specs/rarity_specs.tres")


func _init(
	affixes_service: AffixesService,
	item_bases_service: ItemBasesService,
	game_save_data: GameSaveData
) -> void:
	_affixes_service = affixes_service
	_item_bases_service = item_bases_service
	_game_save_data = game_save_data


# TODO: rename to create_random_item_from_type_and_rarity or something like that
func create_item(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> Item:
	# Get the item bas	e first, as it contains the implicit affix
	var item_base: ItemBase = _item_bases_service.get_random_item_base(item_type)
	var item := Item.new()

	# Fixed properties
	item.level = 1

	# From constructor
	item.client_id = _game_save_data._game_save_id + "__" + Tools.uuid.v4()
	item.type = item_type
	item.rarity = item_rarity

	# Set base-derived properties
	item.name = item_base.name
	item.texture = item_base.texture
	item.base_id = item_base.id
	
	# Set implicit affix from item base
	item.implicit_affix = _affixes_service.create_affix(item_base.implicit_affix.identifier, 0.0)
	
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


func create_item_from_inventory_item_dto(inventory_item_dto: InventoryItemDto) -> Item:
	var item := Item.new()

	item.client_id = inventory_item_dto.client_id
	item.base_id = inventory_item_dto.base_id

	var item_base := _item_bases_service.get_base_from_id(item.base_id)
	item.implicit_affix = _affixes_service.create_affix(item_base.implicit_affix.identifier, inventory_item_dto.implicit_affix_base_value)

	for prefix: ItemAffixDTO in inventory_item_dto.prefixes:
		item.prefixes.append(_affixes_service.create_affix(prefix.identifier, prefix.base_value))

	for suffix: ItemAffixDTO in inventory_item_dto.suffixes:
		item.suffixes.append(_affixes_service.create_affix(suffix.identifier, suffix.base_value))

	item.rarity = inventory_item_dto.rarity
	item.level = inventory_item_dto.level
	item.type = inventory_item_dto.type
	item.name = item_base.name
	item.texture = item_base.texture
	item.is_equipped = inventory_item_dto.is_equipped

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
