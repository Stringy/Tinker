extends KinematicBody2D

onready var sprites = $Sprites
onready var controller = $Controller

enum Kind {
	white,
	light_brown,
}

enum State {
	Walking,
	Sitting,
	Eating,
}

export (Kind) var chicken_kind
export (float) var update_seconds_base = 1.0;

var state = State.Walking
var last_state_update = OS.get_ticks_msec()
var state_weights = {
	State.Eating: 0.3,
	State.Sitting: 0.1,
	State.Walking: 0.5
}

func _ready():
	sprites.play(_resolve_animation("run"))
	state = _next_state()
	
func _init():
	randomize()
	
func _process(delta):
	var update_seconds = update_seconds_base + randf()
	if Utils.should_update(last_state_update, update_seconds):
		self.state = _next_state()
		last_state_update = OS.get_ticks_msec()
		print(State.keys()[self.state])
		
	if self.state == State.Eating:
		sprites.play(_resolve_animation("peck"))
	elif self.state == State.Sitting:
		sprites.play(_resolve_animation("sit"))
	else:
		sprites.play(_resolve_animation("run"))
		var direction = controller.calculate_movement()
		if Utils.get_animation_direction(direction) == "right":
			sprites.flip_h = true
		else:
			sprites.flip_h = false
		self.move_and_slide(direction)
	
func _resolve_animation(name):
	var kind = Kind.keys()[chicken_kind]
	return kind.to_lower() + "_" + name
	
func _next_state():
	var eating = randf() * state_weights[State.Eating]
	var sitting = randf() * state_weights[State.Sitting]
	
	if self.state == State.Sitting:
		# if sitting, give a bit more weight to continue sitting
		# but not so much as to prevent the chicken from moving again
		sitting = randf() * state_weights[State.Sitting] * 5
	
	var walking = randf() * state_weights[State.Walking]
	
	var biggest = max(walking, max(eating, sitting))
	if biggest == eating:
		return State.Eating
	elif biggest == sitting:
		return State.Sitting
	else:
		return State.Walking