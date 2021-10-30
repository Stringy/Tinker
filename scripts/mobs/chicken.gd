extends KinematicBody2D

onready var sprites = $Sprites

enum Kind {
	white,
	light_brown,
}

export (Kind) var chicken_kind

func _ready():
	print(_resolve_animation("peck"))
	sprites.play(_resolve_animation("peck"))
	
func _resolve_animation(name):
	var kind = Kind.keys()[chicken_kind]
	return kind.to_lower() + "_" + name
