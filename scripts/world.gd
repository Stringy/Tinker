extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Terrain._generate_world($Player.position)
	$Player.connect("moved", $Terrain, "_generate_world")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# $Terrain._generate_world($Player.position)
	OS.set_window_title("Tinker | fps: " + str(Engine.get_frames_per_second()))
	var pos = $Terrain/Ground.world_to_map($Player.position)
	$GUI/Label.text = "Player: " + str(pos)
