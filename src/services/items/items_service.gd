# gdlint: disable = max-returns

class_name ItemsService

# INFO: Since this class is static, it is not possible to use
# exports for resources since we have no attached scene
var _item_factory_service: ItemFactoryService


func _init(
	item_factory_service: ItemFactoryService
) -> void:
	_item_factory_service = item_factory_service

func create_item(item_type: ItemType.ItemType, item_rarity: ItemRarity.ItemRarity) -> Item:
	return _item_factory_service.create_item(item_type, item_rarity)

# INFO: This is a temporary solution during dev, do not test it
func create_random_item() -> Item:
	var item_type: ItemType.ItemType = ItemType.ItemType.values().pick_random()
	var item_rarity: ItemRarity.ItemRarity = ItemRarity.ItemRarity.values().pick_random()

	return _item_factory_service.create_item(item_type, item_rarity)
