extends KinematicBody2D

export (int) var speed = 200

var target = self.position
var velocity = Vector2()

signal moved(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	self.velocity = (self.target - self.position).normalized() * self.speed
	if (self.target - self.position).length() > 5.0:
		self.velocity = self.move_and_slide(self.velocity)
		emit_signal("moved", self.position)

func _input(event):
	if event.is_action_pressed("click"):
		self.target = self.get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
