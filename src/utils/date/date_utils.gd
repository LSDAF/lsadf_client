class_name DateUtils


## Takes a string date and returns a long unix timestamp
static func parse_date_string(date_str: String) -> int:
	var date := Time.get_unix_time_from_datetime_string(date_str)
	if date == null:
		push_error("Failed to parse date string: {0}".format([date_str]))
		return -1
	return date


## Takes a long unix timestamp and returns a string date
static func format_unix_time_to_date_string(unix_time: int) -> String:
	if unix_time < 0:
		push_error("Invalid unix time: {0}".format([str(unix_time)]))
		return ""
	var date := Time.get_datetime_string_from_unix_time(unix_time)
	if date == null:
		push_error("Failed to format unix time: {0}".format([str(unix_time)]))
		return ""
	return date
