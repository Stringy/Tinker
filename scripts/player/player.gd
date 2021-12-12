extends KinematicBody2D

export (float) var speed: float = 200
export (bool) var is_player: bool = false
export (Resource) var controller
export (Resource) var inventory setget , get_inventory

var velocity: Vector2 = Vector2.ZERO setget , get_velocity
var frames_moved: float = 0
var attacking: bool = false

signal stat_changed(stat)
signal moved(position)
signal is_player(player)
signal is_not_player(player)

onready var sprites = $AnimationPlayer
onready var stats = $Stats

func _ready():
    assert(self.controller is Controller or self.controller == null)

func _physics_process(_delta: float):
    var direction = Vector2()
    if self.is_player:
        if Input.is_action_pressed("forward"):
            direction.y -= 1.0
        if Input.is_action_pressed("backward"):
            direction.y += 1.0
        if Input.is_action_pressed("left"):
            direction.x -= 1.0
        if Input.is_action_pressed("right"):
            direction.x += 1.0
        direction *= self.speed
    elif self.controller:
        direction = self.controller.calculate_movement()

    self.move(direction)

#
# Plays an animation based on the direction. i.e. animate
# in the direction the person is currently travelling in,
# accounting for flipping sprites, etc
#
func animate(direction: Vector2) -> void:
    if direction != Vector2.ZERO:
        sprites.animate_direction(direction, "walk")
        sprites.set_speed_scale(1.5)
        self.velocity = direction
    else:
        sprites.animate_direction(self.velocity, "idle")

#
# Moves the player by the given movement vector, and returns
# the new position for this frame.
#
func move(movement: Vector2):
    if self.attacking:
        return 
    self.animate(movement)
    self.update_moved_frames(movement)
    if movement != Vector2.ZERO:
        self.velocity = self.move_and_slide(movement)
        emit_signal("moved", self.position)

#
# Toggles whether this actor is controlled by the player
# and is considered the current camera
#
func toggle_is_player():
    self.is_player = !self.is_player
    if !self.is_player:
        self.remove_from_group("players")
        emit_signal("is_not_player", self)
    else:
        self.add_to_group("players")
        emit_signal("is_player", self)
        get_tree().call_group("player_observer", "_on_new_player", self)

#
# Gets the current velocity of this person
#
func get_velocity() -> Vector2:
    return velocity

#
# Gets the player's inventory object
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
    sprites.animate_direction(self.velocity, "attack")

#
# Proxy the stats_changed signal up to the next layer
# for ease of instancing.
#
func _on_stats_changed(stat: Stat):
    emit_signal("stat_changed", stat)

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
