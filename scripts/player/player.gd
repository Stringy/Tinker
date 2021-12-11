extends KinematicBody2D

export (int) var speed = 200

export (Resource) var hunger
export (Resource) var thirst
export (Resource) var health
export (Resource) var inventory

var target = self.position
var velocity = Vector2(0, 0) setget, get_velocity
var moved_frames = 0
var attacking = false

signal moved(position)
signal died
signal health_changed(new_health)
signal hunger_changed(new_hunger)
signal thirst_changed(new_thirst)

onready var sprites = $AnimationPlayer

func _ready():
    sprites.connect("animation_finished", self, "stop_attacking")
    
func stop_attacking(_name):
    self.attacking = false
    
func get_velocity():
    return velocity

func _physics_process(_delta: float):
    if attacking:
        return 
    
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
    
    if direction.length() > 0:
        moved_frames += 1
    else:
        moved_frames -= 1
    
    moved_frames = clamp(moved_frames, 0, 100)
    
    self.move_and_slide(direction * self.speed)
    emit_signal("moved", self.position)
    
func animate_player(new_velocity: Vector2):
    if new_velocity != Vector2.ZERO:
        self.velocity = new_velocity
        var animation = sprites.animate_direction(self.velocity, "walk")
        sprites.set_speed_scale(1.5)
        # sprites.frames.set_animation_speed(animation, 2 + 8 * new_velocity.length())
    else:
        sprites.animate_direction(self.velocity, "idle")
    
func deplete_hunger():
    if self.hunger.get_value() <= 0:
        self.take_damage(self, 1)
    else:
        var percent_moved = clamp(self.moved_frames, 0, 100)
        self.hunger.deplete(percent_moved * 0.002)
        emit_signal("hunger_changed", self.hunger.get_value())
        
func deplete_thirst():
    if self.thirst.get_value() <= 0:
        self.take_damage(self, 1)
    else:
        self.thirst.deplete()
        emit_signal("thirst_changed", self.thirst.get_value())

func take_damage(_source, amount):
    self.health.reduce_value(amount)
    if self.health.get_value() <= 0:
        # $Sprite.play("death")
        emit_signal("died")
    else:
        emit_signal("health_changed", self.health.get_value())

func update_stats():
    self.deplete_hunger()
    self.deplete_thirst()
    
func get_inventory() -> Inventory:
    return self.inventory

func try_use_item(_position):
    var item: Item = self.inventory.get_selected_item()
    if item:
        item.use(self)
        if item.consumable():
            self.inventory.remove_selected_item()
    else:
        self.try_attack()

func try_attack():
    self.attacking = true
    sprites.animate_direction(self.velocity, "attack")

func _on_Melee_body_entered(body: Node):
    if body.get("health") != null and body.health is Health:
        body.health.reduce_value(100)
