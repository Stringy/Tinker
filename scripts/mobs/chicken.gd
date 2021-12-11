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
export (bool) var randomize_kind = true
export (float) var update_seconds_base = 1.0;

var health = Health.new()

var chicken_drop = preload("res://resources/items/chicken_leg.tres")
var item = preload("res://scenes/item.tscn")

var state = State.Walking
var last_state_update = OS.get_ticks_msec()
var state_weights = {
    State.Eating: 0.3,
    State.Sitting: 0.1,
    State.Walking: 0.5
}

func _ready():
    if randomize_kind:
        chicken_kind = Kind.get(Kind.keys()[randi() % Kind.keys().size()])
    
    sprites.play(_resolve_animation("run"))
    state = _next_state()
    
    health.connect("value_zero", self, "die")
    
func die():
    var new_item = item.instance()
    new_item.item = chicken_drop.duplicate()
    new_item.position = self.position + Vector2(randi() % 50, randi() % 50)
    get_parent().add_child(new_item)
    
    new_item = item.instance()
    new_item.item = chicken_drop.duplicate()
    new_item.position = self.position + Vector2(randi() % 50, randi() % 50)
    get_parent().add_child(new_item)
    
    queue_free()

func _init():
    randomize()
    
func _process(delta):
    var update_seconds = update_seconds_base + randf()
    if Utils.should_update(last_state_update, update_seconds):
        self.state = _next_state()
        last_state_update = OS.get_ticks_msec()
        
    if self.state == State.Eating:
        sprites.play(_resolve_animation("peck"))
    elif self.state == State.Sitting:
        sprites.play(_resolve_animation("sit"))
    else:
        sprites.play(_resolve_animation("run"))
        var velocity = controller.calculate_movement()
        if Utils.get_animation_direction(velocity) == "right":
            sprites.flip_h = true
        else:
            sprites.flip_h = false
        self.move_and_slide(velocity)
    
func _resolve_animation(name):
    var kind = Kind.keys()[chicken_kind]
    return kind.to_lower() + "_" + name
    
func _next_state():
    var adjusted_weights = Utils.copy(state_weights)
    if self.state == State.Sitting:
        # if sitting, give a bit more weight to continue sitting
        # but not so much as to prevent the chicken from moving again
        adjusted_weights[State.Sitting] = state_weights[State.Sitting] * 6
    return Utils.weighted_result(state_weights)
