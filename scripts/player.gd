extends KinematicBody2D

export (int) var speed = 200

var target = self.position
var velocity = Vector2()
var last_direction = Vector2(0, 1)
var flip_x = false

signal moved(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta: float):
	var direction = Vector2()
	if Input.is_action_pressed("forward"):
		direction.y -= 1.0
	if Input.is_action_pressed("backward"):
		direction.y += 1.0
	if Input.is_action_pressed("left"):
		direction.x -= 1.0
	if Input.is_action_pressed("right"):
		direction.x += 1.0
		
	animate_player(direction)
		
	self.velocity = direction * self.speed * delta
	self.position += self.velocity
	emit_signal("moved", self.position)

func _input(event: InputEvent):
	if event.is_action_pressed("click"):
		self.target = self.get_global_mouse_position()
		
func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"
	
func animate_player(direction: Vector2):
	var flip_x = false
	if direction != Vector2.ZERO:
		last_direction = direction
		var animation = get_animation_direction(last_direction)
		flip_x = animation == "right"
		if animation == "left" or animation == "right":
			animation = "side"
			
		animation = animation + "_walk"
		$Sprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		$Sprite.play(animation)
	else:
		var animation = get_animation_direction(last_direction)
		flip_x = animation == "right"
		if animation == "left" or animation == "right":
			animation = "side"
		animation = animation + "_idle"
		$Sprite.play(animation)
	
	$Sprite.flip_h = flip_x
