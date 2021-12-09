extends CanvasLayer


func _input(event: InputEvent):
    if event.is_action_pressed("toggle_debug"):
        $Grid.visible = !$Grid.visible
        
func process_debug(terrain, player):
    var pos = terrain.world_to_map(player.position)
    $Grid/Coords.text = "x: " + str(pos.x) + ", y: " + str(pos.y)
    $Grid/FPS.text = "FPS: " + str(Engine.get_frames_per_second())

func is_active():
    return $Grid.visible
