class_name RaritySpecs
extends Resource

@export var normal: RaritySpec
@export var common: RaritySpec
@export var uncommon: RaritySpec
@export var magic: RaritySpec
@export var rare: RaritySpec
@export var legendary: RaritySpec
@export var unique: RaritySpec


func get_rarity_spec(item_rarity: ItemRarity.ItemRarity) -> RaritySpec:
	var rarity_spec: RaritySpec

	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			rarity_spec = normal
		ItemRarity.ItemRarity.COMMON:
			rarity_spec = common
		ItemRarity.ItemRarity.UNCOMMON:
			rarity_spec = uncommon
		ItemRarity.ItemRarity.MAGIC:
			rarity_spec = magic
		ItemRarity.ItemRarity.RARE:
			rarity_spec = rare
		ItemRarity.ItemRarity.LEGENDARY:
			rarity_spec = legendary
		ItemRarity.ItemRarity.UNIQUE:
			rarity_spec = unique
		_:
			printerr("Unknown rarity")
			rarity_spec = normal

	return rarity_spec
