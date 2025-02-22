class_name ItemRarity

enum ItemRarity {
	NORMAL,
	COMMON,
	UNCOMMON,
	MAGIC,
	RARE,
	LEGENDARY,
	UNIQUE,
}


static func _prettify_rarity(item_rarity: ItemRarity.ItemRarity) -> String:
	var prettified_rarity := ""

	match item_rarity:
		ItemRarity.ItemRarity.NORMAL:
			prettified_rarity = "Normal"
		ItemRarity.ItemRarity.COMMON:
			prettified_rarity = "Common"
		ItemRarity.ItemRarity.UNCOMMON:
			prettified_rarity = "Uncommon"
		ItemRarity.ItemRarity.MAGIC:
			prettified_rarity = "Magic"
		ItemRarity.ItemRarity.RARE:
			prettified_rarity = "Rare"
		ItemRarity.ItemRarity.LEGENDARY:
			prettified_rarity = "Legendary"
		ItemRarity.ItemRarity.UNIQUE:
			prettified_rarity = "Unique"
		_:
			prettified_rarity = "?NO_RARITY"

	return prettified_rarity
