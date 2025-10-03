class_name DateUtilsTest

extends GutTest


func test_parse_date_string() -> void:
	# Arrange
	var date_str: String = "2023-10-05 14:30:00"
	var expected_unix_time: int = 1696516200  # Corresponding unix timestamp

	# Act
	var result: int = DateUtils.parse_date_string(date_str)

	# Assert
	assert_eq(result, expected_unix_time)


func test_parse_date_string_with_different_format() -> void:
	# Arrange
	var date_str: String = "2023-10-05T14:30:00.000Z"
	var expected_unix_time: int = 1696516200  # Corresponding unix timestamp

	# Act
	var result: int = DateUtils.parse_date_string(date_str)

	# Assert
	assert_eq(result, expected_unix_time)


func test_parse_date_string_with_invalid_date() -> void:
	# Arrange
	var date_str: String = "invalid-date"
	# Act
	var result: int = DateUtils.parse_date_string(date_str)
	# Assert
	assert_eq(result, -1)


func test_format_unix_time_to_date_string() -> void:
	# Arrange
	var unix_time: int = 1696516200  # Corresponding to "2023-10-05 14:30:00"
	var expected_date_str: String = "2023-10-05T14:30:00"

	# Act
	var result: String = DateUtils.format_unix_time_to_date_string(unix_time)

	# Assert
	assert_eq(result, expected_date_str)


func test_format_unix_time_to_date_string_with_invalid_time() -> void:
	# Arrange
	var unix_time: int = -1  # Invalid unix time
	# Act
	var result: String = DateUtils.format_unix_time_to_date_string(unix_time)
	# Assert
	assert_eq(result, "")


func test_compare_datetime_dicts_earlier_year() -> void:
	# Arrange
	var date1 = {"year": 2022, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, -1, "Earlier year should return -1")


func test_compare_datetime_dicts_later_year() -> void:
	# Arrange
	var date1 = {"year": 2024, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 1, "Later year should return 1")


func test_compare_datetime_dicts_earlier_month() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 9, "day": 5, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, -1, "Earlier month should return -1")


func test_compare_datetime_dicts_later_month() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 11, "day": 5, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 1, "Later month should return 1")


func test_compare_datetime_dicts_earlier_day() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 4, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, -1, "Earlier day should return -1")


func test_compare_datetime_dicts_later_day() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 6, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 1, "Later day should return 1")


func test_compare_datetime_dicts_earlier_hour() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 13, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, -1, "Earlier hour should return -1")


func test_compare_datetime_dicts_later_hour() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 15, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 1, "Later hour should return 1")


func test_compare_datetime_dicts_earlier_minute() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 29, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, -1, "Earlier minute should return -1")


func test_compare_datetime_dicts_later_minute() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 31, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 1, "Later minute should return 1")


func test_compare_datetime_dicts_earlier_second() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 1}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, -1, "Earlier second should return -1")


func test_compare_datetime_dicts_later_second() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 2}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 1}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 1, "Later second should return 1")


func test_compare_datetime_dicts_equal() -> void:
	# Arrange
	var date1 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}
	var date2 = {"year": 2023, "month": 10, "day": 5, "hour": 14, "minute": 30, "second": 0}

	# Act
	var result = DateUtils.compare_datetime_dicts(date1, date2)

	# Assert
	assert_eq(result, 0, "Equal dates should return 0")
