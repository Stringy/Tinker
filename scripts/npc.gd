extends KinematicBody2D

export (float) var speed = 175
export (NodePath) var leader

onready var controller = $Controller
onready var sprites = $AnimatedSprite

var wander = preload("res://scripts/controllers/wander.gd")
var follow = preload("res://scripts/controllers/follow.gd")

# store the old velocity so we don't end up looking down
# when we stop.
var old_velocity = Vector2()

func _ready():
    controller.set_script(wander)
    controller.speed = speed
    
func get_velocity():
    return controller.get_velocity()

func _process(_delta):
    var velocity = controller.calculate_movement()
    if velocity == Vector2.ZERO:
        self.animate_direction(old_velocity, "idle")
    else:
        self.animate_direction(velocity, "walk")
        old_velocity = velocity
    self.move_and_slide(velocity)
    
func animate_direction(direction: Vector2, action: String) -> String:
    var anim_direction = Utils.get_animation_direction(direction)
    var flip = anim_direction == "right"
    if anim_direction == "left" or anim_direction == "right":
        anim_direction = "side"
        
    var animation = anim_direction + "_" + action
    sprites.flip_h = flip
    sprites.play(animation)
    return animation
