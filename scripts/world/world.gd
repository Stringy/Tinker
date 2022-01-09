extends Node2D

export (int) var max_spawned = 10
export (float, 0.0, 10.0) var spawn_interval = 1.0

export (Array, PackedScene) var spawnable = [] 

var spawned = []
var last_spawn_time = 0

func _ready():
    assert(self.spawnable.size() > 0)
    last_spawn_time = OS.get_ticks_msec()
    
func _physics_process(_delta: float):
    if not Utils.should_update(last_spawn_time, spawn_interval):
        return
    
    if len(self.spawned) >= self.max_spawned:
        return
    
    last_spawn_time = OS.get_ticks_msec()
    var scene = self.spawnable[randi() % self.spawnable.size()]
    self.spawn(scene)
    
func spawn(scene: PackedScene):
    var inst = scene.instance()
    var pos = self.get_spawn_position()
    inst.position = pos + Vector2(20, 0)
    inst.add_to_group("mobs")
    add_child(inst)
    self.spawned.push_back(inst)
    if inst.has_signal("dead"):
        inst.connect("dead", self, "_remove_dead_entity")
    
func get_spawn_position() -> Vector2:
    var player = Utils.get_player().position
    var viewport = get_viewport_rect()
    var lower_x = player.x - (viewport.size.x / 2)
    var lower_y = player.y - (viewport.size.y / 2)
    var upper_x = player.x + (viewport.size.x / 2)
    var upper_y = player.y + (viewport.size.y / 2)
    
    var x = rand_range(lower_x - 200, lower_x)
    var y = rand_range(lower_y - 200, lower_y)
    
    if int(x) % 2 == 0:
        x = rand_range(upper_x, upper_x + 200)
    if int(y) % 2 == 0:
        y = rand_range(upper_y, upper_y + 200)
        
    return Vector2(x, y)

func _on_CullingRange_body_exited(body):
    if body in self.spawned:
        self.spawned.remove(self.spawned.find(body))
        body.queue_free()
        
func _remove_dead_entity(entity):
    if entity in self.spawned:
        self.spawned.remove(self.spawned.find(entity))
