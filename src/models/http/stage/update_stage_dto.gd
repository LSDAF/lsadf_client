class_name UpdateStageDto

var current_stage: int
var max_stage: int
var wave: int


func _init(dictionary: Dictionary) -> void:
	current_stage = dictionary["current_stage"]
	max_stage = dictionary["max_stage"]
	wave = dictionary["wave"]


func to_dictionary() -> Dictionary:
	return {"current_stage": current_stage, "max_stage": max_stage, "wave": wave}
