extends GutTest

var sut: PolynomialScaler


func before_each() -> void:
	sut = PolynomialScaler.new()


func test_calculate_with_default_values() -> void:
	# Arrange
	sut.base = 1.0
	sut.linear_coef = 2.0
	sut.exponent = 1.02

	# Act
	var result := sut.calculate(5)

	# Assert
	assert_almost_eq(result, 2.0 * 5 + pow(5, 1.02), 0.0001)


func test_calculate_with_custom_values() -> void:
	# Arrange
	sut.base = 2.0
	sut.linear_coef = 3.0
	sut.exponent = 2.0

	# Act
	var result := sut.calculate(3)

	# Assert
	assert_eq(result, 36.0)  # 2.0 * (3.0 * 3 + 3^2) = 2 * (9 + 9) = 2 * 18 = 36


func test_calculate_with_zero_value() -> void:
	# Arrange
	sut.base = 1.5
	sut.linear_coef = 2.0
	sut.exponent = 1.5

	# Act
	var result := sut.calculate(0)

	# Assert
	assert_eq(result, 0.0)
