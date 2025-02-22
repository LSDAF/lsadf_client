class_name AffixScaling

## Scaling types for item affixes
## LINEAR: value * level
## SQRT: sqrt(value * level)
## EXPONENTIAL: pow(level, 1.02)
## POLYNOMIAL: 2 * level + pow(level, 1.02)
enum ScalingType { LINEAR, SQRT, EXPONENTIAL, POLYNOMIAL }


static func calculate_value(base_value: float, level: int, scaling_type: ScalingType) -> float:
	match scaling_type:
		ScalingType.LINEAR:
			return base_value * level
		ScalingType.SQRT:
			return sqrt(base_value * level)
		ScalingType.EXPONENTIAL:
			return base_value * pow(level, 1.02)
		ScalingType.POLYNOMIAL:
			return base_value * (2 * level + pow(level, 1.02))
		_:
			return base_value  # Fallback to no scaling


static func get_scaling_description(scaling_type: ScalingType) -> String:
	match scaling_type:
		ScalingType.LINEAR:
			return "Linear scaling"
		ScalingType.SQRT:
			return "Square root scaling (soft cap)"
		ScalingType.EXPONENTIAL:
			return "Small exponential scaling"
		ScalingType.POLYNOMIAL:
			return "Small polynomial scaling"
		_:
			return "Unknown scaling"
