extends KinematicBody2D

export (float) var speed = 175

onready var controller = $Controller
onready var sprites = $AnimatedSprite

func _process(delta):
	var direction = controller.calculate_movement()
	sprites.animate_direction(direction, "walk")
	self.move_and_slide(direction * speed * delta)
