extends KinematicBody2D

export (float) var speed = 175
export (NodePath) var leader

onready var controller = $Controller
onready var sprites = $AnimatedSprite

func _ready():
    $Controller.leaderPath = "../" + leader

func _process(delta):
    var velocity = controller.calculate_movement()
    print(velocity)
    if velocity.abs() < Vector2(15.0, 15.0):
        sprites.animate_direction(velocity, "idle")
        velocity = Vector2.ZERO
    else:
        sprites.animate_direction(velocity, "walk")
    self.move_and_slide(velocity)
