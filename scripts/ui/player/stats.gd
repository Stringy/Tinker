extends Control

var hunger = preload("res://resources/player/hunger.tres")
var thirst = preload("res://resources/player/thirst.tres")
var health = preload("res://resources/player/health.tres")

func _ready():
	hunger.connect("value_changed", self, "set_hunger")
	thirst.connect("value_changed", self, "set_thirst")
	health.connect("value_changed", self, "set_health")

	set_hunger(hunger.get_value(), 0.0)
	set_thirst(thirst.get_value(), 0.0)
	set_health(health.get_value(), 0.0)

func set_hunger(new_hunger, change):
	_set_stat_ui($Hunger, "Hunger", new_hunger, change)

func set_thirst(new_thirst, change):
	_set_stat_ui($Thirst, "Thirst", new_thirst, change)

func set_health(new_health, change):
	_set_stat_ui($Health, "Health", new_health, change)

func _set_stat_ui(label: Label, name: String, new_value, change):
	label.text = ("%s: %03.2f (%+0.2f)" % [name, new_value, change])
