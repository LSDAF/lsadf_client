class_name ItemAffix
extends Resource

@export var statistic: ItemStatistics.ItemStatistics
@export var base_value: float
@export var affix_type: AffixType.AffixType
@export var affix_role: AffixType.AffixRole
@export var scaling_type: AffixScaling.ScalingType
@export var allowed_item_types: Array[ItemType.ItemType]


func _init(
	_statistic: ItemStatistics.ItemStatistics,
	_base_value: float,
	_affix_type: AffixType.AffixType,
	_affix_role: AffixType.AffixRole,
	_scaling_type: AffixScaling.ScalingType,
	_allowed_item_types: Array[ItemType.ItemType]
) -> void:
	statistic = _statistic
	base_value = _base_value
	affix_type = _affix_type
	affix_role = _affix_role
	scaling_type = _scaling_type
	allowed_item_types = _allowed_item_types


func calculate_value(level: int) -> float:
	return AffixScaling.calculate_value(base_value, level, scaling_type)


func can_roll_on_item_type(item_type: ItemType.ItemType) -> bool:
	return allowed_item_types.has(item_type)


func to_dictionary() -> Dictionary:
	return {
		"statistic": ItemStatistics.ItemStatistics.keys()[statistic],
		"base_value": base_value,
		"affix_type": AffixType.AffixType.keys()[affix_type],
		"affix_role": AffixType.AffixRole.keys()[affix_role],
		"scaling_type": AffixScaling.ScalingType.keys()[scaling_type],
		"allowed_item_types":
		allowed_item_types.map(
			func(type: ItemType.ItemType) -> String: return ItemType.ItemType.keys()[type]
		)
	}


static func from_dictionary(dict: Dictionary) -> ItemAffix:
	return ItemAffix.new(
		ItemStatistics.ItemStatistics[dict["statistic"]],
		dict["base_value"],
		AffixType.AffixType[dict["affix_type"]],
		AffixType.AffixRole[dict["affix_role"]],
		AffixScaling.ScalingType[dict["scaling_type"]],
		dict["allowed_item_types"].map(
			func(type: String) -> ItemType.ItemType: return ItemType.ItemType[type]
		)
	)
