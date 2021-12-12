extends KinematicBody2D

export (float) var speed: float = 200

onready var person: Node2D = $Person

var velocity: Vector2 = Vector2.ZERO setget , get_velocity
var frames_moved: float = 0

signal stat_changed(stat)
signal moved(position)

func _physics_process(_delta: float):
    var direction = Vector2()
    if Input.is_action_pressed("forward"):
        direction.y -= 1.0
    if Input.is_action_pressed("backward"):
        direction.y += 1.0
    if Input.is_action_pressed("left"):
        direction.x -= 1.0
    if Input.is_action_pressed("right"):
        direction.x += 1.0

    self.move(direction * self.speed)

#
# Moves the player by the given movement vector, and returns
# the new position for this frame.
#
func move(movement: Vector2):
    if person.attacking:
        return 
    person.animate(movement)
    person.update_moved_frames(movement)
    self.velocity = self.move_and_slide(movement)
    emit_signal("moved", self.position)

#
# Gets the current velocity of this person
#
func get_velocity() -> Vector2:
    return velocity

#
# Gets the player's inventory object
#
func get_inventory() -> Inventory:
    return person.inventory

#
# Proxy calls to try use item, down to the implementation
#
func try_use_item(position):
    return person.try_use_item(position)

#
# Proxy the stats_changed signal up to the next layer
# for ease of instancing.
#
func _on_stats_changed(stat: Stat):
    emit_signal("stat_changed", stat)
