extends GutTest

var sut: AffixPool


func before_each() -> void:
	sut = AffixPool.new()


func test_prefix_pool_contains_correct_affixes() -> void:
	# Arrange
	var flat_attack := ItemAffix.new(
		ItemStatistics.ItemStatistics.ATTACK_ADD,
		10.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)
	var percent_attack := ItemAffix.new(
		ItemStatistics.ItemStatistics.ATTACK_MULT,
		5.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.EXPONENTIAL,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)
	var flat_hp := ItemAffix.new(
		ItemStatistics.ItemStatistics.HEALTH_ADD,
		50.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[
			ItemType.ItemType.CHESTPLATE,
			ItemType.ItemType.HELMET,
			ItemType.ItemType.SHIELD,
			ItemType.ItemType.BOOTS
		]
	)
	var percent_hp := ItemAffix.new(
		ItemStatistics.ItemStatistics.HEALTH_MULT,
		3.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.EXPONENTIAL,
		[
			ItemType.ItemType.CHESTPLATE,
			ItemType.ItemType.HELMET,
			ItemType.ItemType.SHIELD,
			ItemType.ItemType.BOOTS
		]
	)
	var crit_chance := ItemAffix.new(
		ItemStatistics.ItemStatistics.CRIT_CHANCE,
		2.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)
	var basic_attack_damage := ItemAffix.new(
		ItemStatistics.ItemStatistics.BASIC_ATTACK_DMG,
		5.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)

	# Act
	sut.add_affix(flat_attack)
	sut.add_affix(percent_attack)
	sut.add_affix(flat_hp)
	sut.add_affix(percent_hp)
	sut.add_affix(crit_chance)
	sut.add_affix(basic_attack_damage)

	# Assert
	assert_eq(sut.prefixes.size(), 6)
	assert_has(sut.prefixes, flat_attack)
	assert_has(sut.prefixes, percent_attack)
	assert_has(sut.prefixes, flat_hp)
	assert_has(sut.prefixes, percent_hp)
	assert_has(sut.prefixes, crit_chance)
	assert_has(sut.prefixes, basic_attack_damage)


func test_suffix_pool_contains_correct_affixes() -> void:
	# Arrange
	var crit_damage := ItemAffix.new(
		ItemStatistics.ItemStatistics.CRIT_DAMAGE,
		10.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.EXPONENTIAL,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)
	var cooldown_reduction := ItemAffix.new(
		ItemStatistics.ItemStatistics.CDR,
		5.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.UTILITY,
		AffixScaling.ScalingType.SQRT,
		[ItemType.ItemType.HELMET, ItemType.ItemType.BOOTS]
	)
	var skill_level := ItemAffix.new(
		ItemStatistics.ItemStatistics.SKILL_LEVEL,
		1.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.SWORD, ItemType.ItemType.SHIELD, ItemType.ItemType.GLOVES]
	)
	var movement_speed := ItemAffix.new(
		ItemStatistics.ItemStatistics.MOVEMENT_SPEED,
		5.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.MOBILITY,
		AffixScaling.ScalingType.SQRT,
		[ItemType.ItemType.BOOTS]
	)
	var final_attack := ItemAffix.new(
		ItemStatistics.ItemStatistics.ATTACK_FINAL,
		3.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)
	var final_hp := ItemAffix.new(
		ItemStatistics.ItemStatistics.HP_FINAL,
		3.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[
			ItemType.ItemType.CHESTPLATE,
			ItemType.ItemType.HELMET,
			ItemType.ItemType.SHIELD,
			ItemType.ItemType.BOOTS
		]
	)
	var hp_regen := ItemAffix.new(
		ItemStatistics.ItemStatistics.HP_REGEN,
		2.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.CHESTPLATE, ItemType.ItemType.HELMET, ItemType.ItemType.SHIELD]
	)
	var hp_regen_mult := ItemAffix.new(
		ItemStatistics.ItemStatistics.HP_REGEN,
		5.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.EXPONENTIAL,
		[ItemType.ItemType.CHESTPLATE, ItemType.ItemType.HELMET, ItemType.ItemType.SHIELD]
	)
	var hp_regen_cdr := ItemAffix.new(
		ItemStatistics.ItemStatistics.HP_REGEN_CDR,
		5.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.SQRT,
		[ItemType.ItemType.CHESTPLATE, ItemType.ItemType.HELMET, ItemType.ItemType.SHIELD]
	)
	var attack_speed := ItemAffix.new(
		ItemStatistics.ItemStatistics.ATTACK_SPEED,
		5.0,
		AffixType.AffixType.SUFFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.SQRT,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)

	# Act
	sut.add_affix(crit_damage)
	sut.add_affix(cooldown_reduction)
	sut.add_affix(skill_level)
	sut.add_affix(movement_speed)
	sut.add_affix(final_attack)
	sut.add_affix(final_hp)
	sut.add_affix(hp_regen)
	sut.add_affix(hp_regen_mult)
	sut.add_affix(hp_regen_cdr)
	sut.add_affix(attack_speed)

	# Assert
	assert_eq(sut.suffixes.size(), 10)
	assert_has(sut.suffixes, crit_damage)
	assert_has(sut.suffixes, cooldown_reduction)
	assert_has(sut.suffixes, skill_level)
	assert_has(sut.suffixes, movement_speed)
	assert_has(sut.suffixes, final_attack)
	assert_has(sut.suffixes, final_hp)
	assert_has(sut.suffixes, hp_regen)
	assert_has(sut.suffixes, hp_regen_mult)
	assert_has(sut.suffixes, hp_regen_cdr)
	assert_has(sut.suffixes, attack_speed)


func test_get_available_affixes_by_role_returns_correct_affixes() -> void:
	# Arrange
	var flat_attack := ItemAffix.new(
		ItemStatistics.ItemStatistics.ATTACK_ADD,
		10.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.OFFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[ItemType.ItemType.GLOVES, ItemType.ItemType.SWORD]
	)
	var flat_hp := ItemAffix.new(
		ItemStatistics.ItemStatistics.HEALTH_ADD,
		50.0,
		AffixType.AffixType.PREFIX,
		AffixType.AffixRole.DEFENSIVE,
		AffixScaling.ScalingType.LINEAR,
		[
			ItemType.ItemType.CHESTPLATE,
			ItemType.ItemType.HELMET,
			ItemType.ItemType.SHIELD,
			ItemType.ItemType.BOOTS
		]
	)
	sut.add_affix(flat_attack)
	sut.add_affix(flat_hp)

	# Act
	var offensive_affixes := sut.get_available_affixes_by_role(
		AffixType.AffixType.PREFIX, ItemType.ItemType.GLOVES, AffixType.AffixRole.OFFENSIVE
	)
	var defensive_affixes := sut.get_available_affixes_by_role(
		AffixType.AffixType.PREFIX, ItemType.ItemType.BOOTS, AffixType.AffixRole.DEFENSIVE
	)

	# Assert
	assert_eq(offensive_affixes.size(), 1)
	assert_has(offensive_affixes, flat_attack)
	assert_eq(defensive_affixes.size(), 1)
	assert_has(defensive_affixes, flat_hp)
