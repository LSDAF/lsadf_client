class_name ItemStatistics

enum ItemStatistics {
	ATTACK_ADD,  # Attack Add
	ATTACK_MULT,  # Attack Mult
	CRIT_CHANCE,  # Crit Chance
	CRIT_DAMAGE,  # Crit Damage
	HEALTH_ADD,  # Health Add
	HEALTH_MULT,  # Health Mult
	RESISTANCE_ADD,  # Resistance Add
	RESISTANCE_MULT,  # Resistance Mult
	CDR,  # Cooldown Reduction
	MOVEMENT_SPEED,  # Movement Speed
	SKILL_LEVEL,  # Skill Level bonus
	HP_REGEN_ADD,  # HP Regeneration Add
	HP_REGEN_MULT, # HP Regen Mult
	HP_REGEN_CDR,  # HP Regen Cooldown
	ATTACK_SPEED,  # Attack Speed
	BASIC_ATTACK_DMG,  # Basic Attack Damage
	ARMOR,  # Armor
	ATTACK_FINAL,  # Final Attack Multiplier
	HP_FINAL,  # Final HP Multiplier
}


static func _prettify_statistic(
	item_statistic: ItemStatistics.ItemStatistics, current_value: float
) -> String:
	var prettified_statistic := ""

	match item_statistic:
		# Base stats
		ItemStatistics.ItemStatistics.ATTACK_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.ATTACK_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.CRIT_CHANCE:
			prettified_statistic = "+{0}% {1}".format([current_value, "Crit. Chance"])
		ItemStatistics.ItemStatistics.CRIT_DAMAGE:
			prettified_statistic = "+{0}% {1}".format([current_value, "Crit. Damage"])
		ItemStatistics.ItemStatistics.HEALTH_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Health"])
		ItemStatistics.ItemStatistics.HEALTH_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Health"])
		ItemStatistics.ItemStatistics.RESISTANCE_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Resistance"])
		ItemStatistics.ItemStatistics.RESISTANCE_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Resistance"])
		ItemStatistics.ItemStatistics.CDR:
			prettified_statistic = "+{0}% {1}".format([current_value, "Cooldown Reduction"])
		ItemStatistics.ItemStatistics.MOVEMENT_SPEED:
			prettified_statistic = "+{0}% {1}".format([current_value, "Movement Speed"])
		ItemStatistics.ItemStatistics.SKILL_LEVEL:
			prettified_statistic = "+{0} {1}".format([current_value, "to Skill Level"])
		ItemStatistics.ItemStatistics.HP_REGEN_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "HP Regeneration"])
		ItemStatistics.ItemStatistics.HP_REGEN_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "HP Regeneration"])
		ItemStatistics.ItemStatistics.HP_REGEN_CDR:
			prettified_statistic = "+{0}% {1}".format([current_value, "HP Regen CDR"])
		ItemStatistics.ItemStatistics.ATTACK_SPEED:
			prettified_statistic = "+{0}% {1}".format([current_value, "Attack Speed"])
		ItemStatistics.ItemStatistics.BASIC_ATTACK_DMG:
			prettified_statistic = "+{0}% {1}".format([current_value, "Basic Attack Damage"])
		ItemStatistics.ItemStatistics.ARMOR:
			prettified_statistic = "+{0} {1}".format([current_value, "Armor"])
		ItemStatistics.ItemStatistics.ATTACK_FINAL:
			prettified_statistic = "+{0}% {1}".format([current_value, "Final Attack"])
		ItemStatistics.ItemStatistics.HP_FINAL:
			prettified_statistic = "+{0}% {1}".format([current_value, "Final HP"])
		_:
			prettified_statistic = "UNSUPPORTED"

	return prettified_statistic
