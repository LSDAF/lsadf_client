class_name ItemAffixDTO

var identifier: AffixEnums.AffixIdentifier
var base_value: float


func _init(dictionary: Dictionary) -> void:
	identifier = AffixEnums.AffixIdentifier[dictionary["identifier"]]
	base_value = dictionary["base_value"]


func to_dictionary() -> Dictionary:
	return {
		"identifier": identifier,
		"base_value": base_value
	}
