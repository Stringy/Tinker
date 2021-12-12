extends Node2D

export (Resource) var inventory setget , get_inventory

var attacking: bool = false
var frames_moved: float = 0
var old_direction: Vector2 = Vector2.ZERO

onready var sprites = $AnimationPlayer
onready var stats = $Stats

signal stat_changed(stat)

func _ready():
    assert(inventory is Inventory, "inventory is incorrect type!")

#
# Plays an animation based on the direction. i.e. animate
# in the direction the person is currently travelling in,
# accounting for flipping sprites, etc
#
func animate(direction: Vector2) -> void:
    if direction != Vector2.ZERO:
        sprites.animate_direction(direction, "walk")
        sprites.set_speed_scale(1.5)
        old_direction = direction
    else:
        sprites.animate_direction(old_direction, "idle")

#
# Gets the current inventory of this person
#
func get_inventory() -> Inventory:
    return inventory

#
# Try to use the selected item from the inventory. If no item
# exists, try to attack.
#
func try_use_item(_position):
    var item: Item = self.inventory.get_selected_item()
    if item and item.use(self.stats):
        if item.consumable():
            self.inventory.remove_selected_item()
    else:
        self.start_attack()

#
# Start an attack, setting flags and animations as necessary
#
func start_attack():
    self.attacking = true
    sprites.animate_direction(self.old_direction, "attack")

#
# Updates the number of frames we've moved, based on the current
# frame's movement, clamped to 100
#
func update_moved_frames(movement: Vector2):
    if movement != Vector2.ZERO:
        self.frames_moved += 1
    else:
        self.frames_moved -= 1
    self.frames_moved = clamp(self.frames_moved, 0, 100)

#
# Called whenever the stats timer goes off, and is used to adjust
# our stats, based on actions that have been taken since the last
# timeout. (i.e. if we have been walking for a long time, hunger
# is depleted more than if we'd remained in one place)
#
func _on_stats_timeout():
    # TODO(giles): not really a percentage...
    var percent_moved = clamp(self.frames_moved, 0, 100)
    stats.update_stats(percent_moved)

#
# Proxy the stats_changed signal up to the next layer
# for ease of instancing.
#
func _on_stats_changed(stat: Stat):
    emit_signal("stat_changed", stat)

#
# Signal handler for our melee attacks hitting a target
#
func _on_melee_attack_hits(body: Node):
    if body.get("health") != null and body.health is Health:
        body.health.reduce_value(100)

#
# Signal handler for when an animation finishes. Returns to default
# idle state.
#
func _on_animation_finished(name: String):
    if name.ends_with("attack"):
        self.attacking = false
    sprites.animate_direction(Vector2.ZERO, "idle")
