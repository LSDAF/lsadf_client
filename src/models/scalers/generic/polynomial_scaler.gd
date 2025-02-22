class_name PolynomialScaler
extends Scaler

## Linear coefficient for the polynomial
@export var linear_coef: float = 2.0
## Exponent for the polynomial term
@export var exponent: float = 1.02


## Configured base times (linear_coef times input value plus value raised to exponent)
func calculate(value: int) -> float:
	return base * (linear_coef * value + pow(value, exponent))
