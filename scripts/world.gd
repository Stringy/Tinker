extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Terrain._generate_world($Player.position)
	
func _input(event):
	if event.is_action_pressed("toggle_debug"):
		$GUI/Container.visible = !$GUI/Container.visible
	
func _process(_delta):
	if $Debug.is_active():
		$Debug.process_debug($Terrain, $Player)

func game_over():
	print("player has died")
	get_tree().paused = true
