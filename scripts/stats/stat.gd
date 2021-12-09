extends Resource
class_name Stat

export (float) var value = 100.0 setget set_value, get_value
export (float) var value_max = 100.0
export (float) var value_min = 0.0

var last_change: float = 0.0 setget , get_last_change

signal value_changed(new_value, difference)

func set_value(new_value: float):
    last_change = new_value - value
    value = clamp(new_value, value_min, value_max)
    emit_signal("value_changed", value, last_change)

func reduce_value(amount: float):
    self.set_value(self.value - amount)
    
func increase_value(amount: float):
    self.set_value(self.value + amount)
    
func get_value() -> float:
    return value
    
func get_last_change() -> float:
    return last_change
