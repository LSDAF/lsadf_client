class_name ItemType

enum ItemType {
	BOOTS,
	CHESTPLATE,
	GLOVES,
	HELMET,
	SHIELD,
	SWORD,
}


static func _prettify_type_short(item_type: ItemType.ItemType) -> String:
	match item_type:
		ItemType.ItemType.BOOTS:
			return "Bo."
		ItemType.ItemType.CHESTPLATE:
			return "Ch."
		ItemType.ItemType.GLOVES:
			return "Gl."
		ItemType.ItemType.HELMET:
			return "He."
		ItemType.ItemType.SHIELD:
			return "Sh."
		ItemType.ItemType.SWORD:
			return "Sw."

	return "Unknown"

static func get_property_name_from_item_type(item_type: ItemType.ItemType) -> String:
	match item_type:
		ItemType.ItemType.BOOTS:
			return "boots"
		ItemType.ItemType.CHESTPLATE:
			return "chestplates"
		ItemType.ItemType.GLOVES:
			return "gloves"
		ItemType.ItemType.HELMET:
			return "helmets"
		ItemType.ItemType.SHIELD:
			return "shields"
		ItemType.ItemType.SWORD:
			return "swords"
	return ""
	