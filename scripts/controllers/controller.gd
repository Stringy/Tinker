extends Resource
class_name Controller

var velocity: Vector2 = Vector2(1, 1) setget , get_velocity

export (float) var speed = 20
export (bool) var enabled = true

func get_velocity() -> Vector2:
    return velocity

func calculate_movement():
    return Vector2()
