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


## Adds seconds to a datetime dictionary and returns a new datetime dictionary
static func add_seconds_to_time(datetime: Dictionary, seconds: int) -> Dictionary:
	if !validate_datetime_dict(datetime):
		return {}
	var new_time := Time.get_unix_time_from_datetime_dict(datetime)
	if new_time == null:
		push_error("Failed to convert date dictionary to unix time: {0}".format([str(datetime)]))
		return {}
	new_time += seconds
	var new_date := Time.get_datetime_dict_from_unix_time(new_time)
	if new_date == null:
		push_error(
			"Failed to convert unix time back to date dictionary: {0}".format([str(new_time)])
		)
		return {}
	return new_date


static func validate_datetime_dict(date: Dictionary) -> bool:
	var required_keys := ["year", "month", "day", "hour", "minute", "second"]
	for key: String in required_keys:
		if not date.has(key):
			push_error("Date dictionary is missing key: {0}".format([key]))
			return false
		if typeof(date[key]) != TYPE_INT:
			push_error("Date dictionary key {0} is not an integer".format([key]))
			return false
		if date[key] < 0:
			push_error("Date dictionary key {0} is not a positive integer".format([key]))
			return false
	return true


## Compares two datetime dictionaries and returns:
## -1 if date1 is before date2
##  0 if date1 is equal to date2
##  1 if date1 is after date2
static func compare_datetime_dicts(date1: Dictionary, date2: Dictionary) -> int:
	# Compare years
	if date1.year < date2.year:
		return -1
	if date1.year > date2.year:
		return 1

	# Same year, compare months
	if date1.month < date2.month:
		return -1
	if date1.month > date2.month:
		return 1

	# Same month, compare days
	if date1.day < date2.day:
		return -1
	if date1.day > date2.day:
		return 1

	# Same day, compare hours
	if date1.hour < date2.hour:
		return -1
	if date1.hour > date2.hour:
		return 1

	# Same hour, compare minutes
	if date1.minute < date2.minute:
		return -1
	if date1.minute > date2.minute:
		return 1

	# Same minute, compare seconds
	if date1.second < date2.second:
		return -1
	if date1.second > date2.second:
		return 1

	# Dates are equal
	return 0
