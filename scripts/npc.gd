extends KinematicBody2D

export (float) var speed = 175
export (NodePath) var leader

onready var controller = $Controller
onready var sprites = $AnimatedSprite

# store the old velocity so we don't end up looking down
# when we stop.
var old_velocity = Vector2()

func _ready():
    var path = "../" + leader
    controller.leaderPath = path
    add_to_group(path)
    
func get_velocity():
    return controller.get_velocity()

func _process(delta):
    var velocity = controller.calculate_movement()
    if velocity == Vector2.ZERO:
        sprites.animate_direction(old_velocity, "idle")
    else:
        sprites.animate_direction(velocity, "walk")
        old_velocity = velocity
    self.move_and_slide(velocity)
