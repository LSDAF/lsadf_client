class_name FetchInventoryDto

var items: Array[InventoryItemDto]


func _init(item_array: Array) -> void:
	for item: Dictionary in item_array:
		items.push_back(InventoryItemDto.new(item))
