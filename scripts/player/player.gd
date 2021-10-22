extends KinematicBody2D

export (int) var speed = 200

var hunger = preload("res://resources/player/hunger.tres")
var thirst = preload("res://resources/player/thirst.tres")
var health = preload("res://resources/player/health.tres")
var inventory = preload("res://resources/player/inventory.tres")

var target = self.position
var velocity = Vector2()
var last_direction = Vector2(0, 1)
var moved_frames = 0

signal moved(position)
signal died
signal health_changed(new_health)
signal hunger_changed(new_hunger)
signal thirst_changed(new_thirst)

func _ready():
	pass
	
func _physics_process(delta: float):
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
		
	self.velocity = direction * self.speed * delta
	self.position += velocity
	emit_signal("moved", self.position)
		
		
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
