class_name GameSessionDto

var id: String
var end_time: String
var version: int


func _init(dictionary: Dictionary) -> void:
	id = dictionary["id"]
	end_time = dictionary["end_time"]
	version = dictionary["version"]
