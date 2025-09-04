class_name FetchInventoryDto

var items: Array[InventoryItemDto]


func _init(items: Array) -> void:
	for item: Dictionary in items:
		items.push_back(InventoryItemDto.new(item))
