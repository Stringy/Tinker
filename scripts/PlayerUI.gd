extends CanvasLayer

var hunger = 100 setget set_hunger

func set_hunger(h):
	_set_stat_ui($Container/Player/Stats/Hunger, "Hunger", hunger, h)
	hunger = h

var thirst = 100 setget set_thirst

func set_thirst(t):
	_set_stat_ui($Container/Player/Stats/Thirst, "Thirst", thirst, t)
	thirst = t

var health = 100 setget set_health

func set_health(h):
	_set_stat_ui($Container/Player/Stats/Health, "Health", health, h)
	health = h


func _set_stat_ui(label: Label, name: String, old_value: float, new_value: float):
	var difference = new_value - old_value
	var signage = ""
	if difference > 0:
		signage = "+"
	
	label.text = ("%s: %03.2f (%+0.2f)" % [name, new_value, difference])
