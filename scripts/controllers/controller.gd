extends Node2D
class_name Controller

var direction: Vector2 = Vector2(1, 1) setget , get_direction

export (float) var speed = 20

func get_direction() -> Vector2:
	return direction

func calculate_movement():
	return Vector2()
