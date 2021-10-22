extends CenterContainer

var inventory = preload("res://resources/player/inventory.tres")

var frame_tex = preload("res://sprites/ui/inventory_frame.png")
var frame_in_use_tex = preload("res://sprites/ui/inventory_frame_inuse.png")
var selected = false

onready var texture = $Texture

func display(item):
	if item is Item:
		texture.texture = item.texture
		
func toggle_selected():
	selected = !selected
	if selected:
		$Frame.texture = frame_in_use_tex
	else:
		$Frame.texture = frame_tex

