class_name ItemBasesService

var _item_bases_data: ItemBasesData

func _init(item_bases_data: ItemBasesData) -> void:
	_item_bases_data = item_bases_data

func get_random_item_base(item_type: ItemType.ItemType) -> ItemBase:
	var property_name: String = ItemType.get_property_name_from_item_type(item_type)
	
	var item_bases_for_type: Array[ItemBase] = _item_bases_data.item_bases.get(property_name)
	return item_bases_for_type[randi() % item_bases_for_type.size()]
