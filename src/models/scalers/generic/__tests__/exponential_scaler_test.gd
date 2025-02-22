extends GutTest

var sut: ExponentialScaler


func before_each():
	sut = ExponentialScaler.new()


func test_calculate_with_default_values():
	# Arrange
	sut.base = 1.0
	sut.exponent = 1.02

	# Act
	var result = sut.calculate(5)

	# Assert
	assert_almost_eq(result, pow(5, 1.02), 0.0001)


func test_calculate_with_custom_values():
	# Arrange
	sut.base = 2.0
	sut.exponent = 2.0

	# Act
	var result = sut.calculate(3)

	# Assert
	assert_eq(result, 18.0)  # 2.0 * (3^2)


func test_calculate_with_zero_value():
	# Arrange
	sut.base = 1.5
	sut.exponent = 1.5

	# Act
	var result = sut.calculate(0)

	# Assert
	assert_eq(result, 0.0)
