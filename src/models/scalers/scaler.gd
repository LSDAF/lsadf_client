class_name Scaler
extends Resource

## Base class for all scalers
## Each scaler implements a specific scaling algorithm

## The base value to scale with
@export var base: float = 1.0


## Virtual method to be implemented by child classes
## Returns the scaled value based on the configured base and provided value
## @param value: The value to scale (x in f(x))
func calculate(_value: int) -> float:
	push_error("Called calculate on base Scaler class")
	return 0.0
