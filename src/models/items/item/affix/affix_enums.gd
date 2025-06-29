class_name AffixEnums

enum AffixType { PREFIX, SUFFIX }

enum AffixRole { OFFENSIVE, DEFENSIVE, UTILITY, MOBILITY }

enum AffixIdentifier { 
	FLAT_ARMOR,
	FINAL_HP,
	FLAT_HP_REGEN,
	FLAT_HP,
	HP_REGEN_CDR,
	PERCENT_HP_REGEN,
	PERCENT_HP,
	MOVEMENT_SPEED,
	ATTACK_SPEED,
	BASIC_ATTACK_DAMAGE,
	CRITICAL_CHANCE,
	CRITICAL_DAMAGE,
	FINAL_ATTACK,
	FLAT_ATTACK,
	PERCENT_ATTACK,
	COOLDOWN_REDUCTION,
	SKILL_LEVEL,
}

const _AffixIdentifierToString: Dictionary[AffixIdentifier, String] = {
	AffixIdentifier.FLAT_ARMOR: "flat_armor",
	AffixIdentifier.FINAL_HP: "final_hp",
	AffixIdentifier.FLAT_HP_REGEN: "flat_hp_regen",
	AffixIdentifier.FLAT_HP: "flat_hp",
	AffixIdentifier.HP_REGEN_CDR: "hp_regen_cdr",
	AffixIdentifier.PERCENT_HP_REGEN: "percent_hp_regen",
	AffixIdentifier.PERCENT_HP: "percent_hp",
	AffixIdentifier.MOVEMENT_SPEED: "movement_speed",
	AffixIdentifier.ATTACK_SPEED: "attack_speed",
	AffixIdentifier.BASIC_ATTACK_DAMAGE: "basic_attack_damage",
	AffixIdentifier.CRITICAL_CHANCE: "critical_chance",
	AffixIdentifier.CRITICAL_DAMAGE: "critical_damage",
	AffixIdentifier.FINAL_ATTACK: "final_attack",
	AffixIdentifier.FLAT_ATTACK: "flat_attack",
	AffixIdentifier.PERCENT_ATTACK: "percent_attack",
	AffixIdentifier.COOLDOWN_REDUCTION: "cooldown_reduction",
	AffixIdentifier.SKILL_LEVEL: "skill_level",
}
	
func get_affix_identifier_string(identifier: AffixIdentifier) -> String:
	return _AffixIdentifierToString[identifier]
