extends KinematicBody2D

export (int) var speed = 200

var target = self.position
var velocity = Vector2()

signal moved(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("forward"):
		direction.y -= 1.0
	if Input.is_action_pressed("backward"):
		direction.y += 1.0
	if Input.is_action_pressed("left"):
		direction.x -= 1.0
	if Input.is_action_pressed("right"):
		direction.x += 1.0
		
	if Input.is_action_pressed("right_click"):
		self.look_at(self.get_global_mouse_position())
		
	self.velocity = direction * self.speed * delta
	self.position += self.velocity
	emit_signal("moved", self.position)

func _input(event):
	if event.is_action_pressed("click"):
		self.target = self.get_global_mouse_position()
