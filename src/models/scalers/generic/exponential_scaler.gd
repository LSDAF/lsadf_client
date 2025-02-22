class_name ExponentialScaler
extends Scaler

## The exponent to use in the calculation
@export var exponent: float = 1.02


## Configured base times the input value raised to the power of exponent
func calculate(value: int) -> float:
	return base * pow(value, exponent)
