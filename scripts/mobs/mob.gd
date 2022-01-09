extends KinematicBody2D
class_name Mob

var health = Health.new()

signal dead(mob)

func _ready():
    self.health.connect("value_zero", self, "die")

func die():
    emit_signal("dead", self)

func hit(damage: float):
    self.health.reduce_value(damage)
