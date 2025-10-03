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
