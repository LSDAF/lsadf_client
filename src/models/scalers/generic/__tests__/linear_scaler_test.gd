extends GutTest

var sut: LinearScaler


func before_each() -> void:
	sut = LinearScaler.new()


func test_calculate_with_default_base() -> void:
	# Arrange
	sut.base = 1.0

	# Act
	var result := sut.calculate(5)

	# Assert
	assert_eq(result, 5.0)


func test_calculate_with_custom_base() -> void:
	# Arrange
	sut.base = 2.5

	# Act
	var result := sut.calculate(4)

	# Assert
	assert_eq(result, 10.0)


func test_calculate_with_zero_value() -> void:
	# Arrange
	sut.base = 1.5

	# Act
	var result := sut.calculate(0)

	# Assert
	assert_eq(result, 0.0)
