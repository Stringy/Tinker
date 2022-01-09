extends CanvasLayer

var last_updated = 0

export (float) var update_freq = 0.5

func _ready():
    self.last_updated = OS.get_system_time_msecs()

func _input(event: InputEvent):
    if event.is_action_pressed("toggle_debug"):
        $Grid.visible = !$Grid.visible
        
func process_debug(player, delta):
    if self.last_updated + delta < update_freq:
        self.last_updated += delta
        return
        
    self.last_updated = 0
    var pos = Utils.world_to_map(player.position)
    $Grid/Coords.text = "x: " + str(pos.x) + ", y: " + str(pos.y)
    $Grid/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
    
    var objects = get_tree().get_nodes_in_group("objects")
    $Grid/Objects.text = "Object #: " + str(len(objects))
    
    var mobs = get_tree().get_nodes_in_group("mobs")
    $Grid/Mobs.text = "Mob #: " + str(len(mobs))

func is_active():
    return $Grid.visible
