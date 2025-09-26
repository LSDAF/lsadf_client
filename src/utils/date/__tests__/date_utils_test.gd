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
