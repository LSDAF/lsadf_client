extends GutTest

var sut: SqrtScaler


func before_each() -> void:
	sut = SqrtScaler.new()


func test_calculate_with_default_base() -> void:
	# Arrange
	sut.base = 1.0

	# Act
	var result := sut.calculate(16)

	# Assert
	assert_eq(result, 4.0)


func test_calculate_with_custom_base() -> void:
	# Arrange
	sut.base = 4.0

	# Act
	var result := sut.calculate(9)

	# Assert
	assert_eq(result, 6.0)  # sqrt(4.0 * 9) = sqrt(36) = 6


func test_calculate_with_zero_value() -> void:
	# Arrange
	sut.base = 1.5

	# Act
	var result := sut.calculate(0)

	# Assert
	assert_eq(result, 0.0)
