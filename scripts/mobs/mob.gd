extends KinematicBody2D
class_name Mob

var health = Health.new()

func _ready():
    self.health.connect("value_zero", self, "die")

func die():
    pass

func hit(damage: float):
    self.health.reduce_value(damage)
