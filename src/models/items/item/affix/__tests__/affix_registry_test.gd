extends GutTest

var sut: AffixRegistry


func before_each() -> void:
	sut = AffixRegistry.new()


func test_get_all_affixes_returns_empty_array_when_no_affixes_found() -> void:
	# Arrange
	# Nothing to arrange, using empty directory

	# Act
	var result := sut.get_all_affixes()

	# Assert
	assert_eq(result.size(), 0)


func test_get_affixes_for_item_type_returns_empty_array_when_no_affixes_found() -> void:
	# Arrange
	# Nothing to arrange, using empty directory

	# Act
	var result := sut.get_affixes_for_item_type(ItemType.ItemType.SWORD)

	# Assert
	assert_eq(result.size(), 0)


func test_get_prefixes_for_item_type_returns_empty_array_when_no_affixes_found() -> void:
	# Arrange
	# Nothing to arrange, using empty directory

	# Act
	var result := sut.get_prefixes_for_item_type(ItemType.ItemType.SWORD)

	# Assert
	assert_eq(result.size(), 0)


func test_get_suffixes_for_item_type_returns_empty_array_when_no_affixes_found() -> void:
	# Arrange
	# Nothing to arrange, using empty directory

	# Act
	var result := sut.get_suffixes_for_item_type(ItemType.ItemType.SWORD)

	# Assert
	assert_eq(result.size(), 0)


func test_get_affixes_by_role_returns_empty_array_when_no_affixes_found() -> void:
	# Arrange
	# Nothing to arrange, using empty directory

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
