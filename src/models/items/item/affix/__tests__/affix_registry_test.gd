extends GutTest

var sut: AffixRegistry
var mock_affixes: Array[ItemAffix]


func before_each() -> void:
	mock_affixes = [
		ItemAffix.new(
			ItemStatistics.ItemStatistics.ATTACK_ADD,
			10.0,
			AffixType.AffixType.PREFIX,
			AffixType.AffixRole.OFFENSIVE,
			AffixScaling.ScalingType.LINEAR,
			[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
		),
		ItemAffix.new(
			ItemStatistics.ItemStatistics.HEALTH_ADD,
			50.0,
			AffixType.AffixType.PREFIX,
			AffixType.AffixRole.DEFENSIVE,
			AffixScaling.ScalingType.LINEAR,
			[ItemType.ItemType.CHESTPLATE, ItemType.ItemType.HELMET]
		),
		ItemAffix.new(
			ItemStatistics.ItemStatistics.CRIT_DAMAGE,
			10.0,
			AffixType.AffixType.SUFFIX,
			AffixType.AffixRole.OFFENSIVE,
			AffixScaling.ScalingType.EXPONENTIAL,
			[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
		),
	]
	sut = AffixRegistry.new()
	# Override the affixes array with our mock data
	sut._affixes = mock_affixes


func test_get_all_affixes_returns_all_affixes() -> void:
	# Arrange
	# Using mock affixes from before_each

	# Act
	var result := sut.get_all_affixes()

	# Assert
	assert_eq(result.size(), 3)
	assert_has(result, mock_affixes[0])
	assert_has(result, mock_affixes[1])
	assert_has(result, mock_affixes[2])


func test_get_affixes_for_item_type_returns_correct_affixes() -> void:
	# Arrange
	# Using mock affixes from before_each

	# Act
	var result := sut.get_affixes_for_item_type(ItemType.ItemType.SWORD)

	# Assert
	assert_eq(result.size(), 2)
	assert_has(result, mock_affixes[0])
	assert_has(result, mock_affixes[2])


func test_get_prefixes_for_item_type_returns_correct_affixes() -> void:
	# Arrange
	# Using mock affixes from before_each

	# Act
	var result := sut.get_prefixes_for_item_type(ItemType.ItemType.SWORD)

	# Assert
	assert_eq(result.size(), 1)
	assert_has(result, mock_affixes[0])


func test_get_suffixes_for_item_type_returns_correct_affixes() -> void:
	# Arrange
	# Using mock affixes from before_each

	# Act
	var result := sut.get_suffixes_for_item_type(ItemType.ItemType.SWORD)

	# Assert
	assert_eq(result.size(), 1)
	assert_has(result, mock_affixes[2])


func test_get_affixes_by_role_returns_empty_array_when_no_affixes_found() -> void:
	# Arrange
	sut._affixes = []

	# Act
	var result := sut.get_affixes_by_role(ItemType.ItemType.SWORD, AffixType.AffixRole.OFFENSIVE)

	# Assert
	assert_eq(result.size(), 0)

# Note: Add more tests after creating some .tres files to test loading functionality
# Example tests to add:
# - test_get_all_affixes_returns_all_affixes_when_affixes_exist
# - test_get_affixes_for_item_type_returns_only_affixes_for_that_type
# - test_get_prefixes_for_item_type_returns_only_prefixes_for_that_type
# - test_get_suffixes_for_item_type_returns_only_suffixes_for_that_type
# - test_get_affixes_by_role_returns_only_affixes_with_that_role
