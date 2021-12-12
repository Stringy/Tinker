extends Node2D

var health: Health
var hunger: Hunger
var thirst: Thirst

signal stat_changed(stat)

func _init():
    self.health = Health.new()
    self.hunger = Hunger.new()
    self.thirst = Thirst.new()

func update_stats(move_percentage: float):
    self.deplete_hunger(move_percentage)
    self.deplete_thirst(move_percentage)

func deplete_hunger(move_percentage: float):
    if self.hunger.get_value() <= 0:
        self.deplete_health(1)
    else:
        self.hunger.deplete(move_percentage)
        emit_signal("stat_changed", self.hunger)

func deplete_thirst(move_percentage: float):
    if self.hunger.get_value() <= 0:
        self.deplete_health(1)
    else:
        self.thirst.deplete(move_percentage)
        emit_signal("stat_changed", self.thirst)

func deplete_health(reduction: float):
    self.health.reduce_value(reduction)
    if self.health.get_value() <= 0:
        emit_signal("no_health")
    else:
        emit_signal("stat_changed", self.health)
