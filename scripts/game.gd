extends Node2D

onready var ui_container = $GUI/Container
onready var player = $World/Player
onready var ground = $Terrain/Ground
onready var objects = $World/Objects
onready var generation_area = $TerrainBounds
onready var generation_shape = $TerrainBounds/CollisionShape2D
onready var culling_area = $World/Player/CullingRange/CollisionShape2D
onready var ui_overlay = $UIOverlay

export (Vector2) var world_size = Vector2(128, 128)

var item_scene = preload("res://scenes/item.tscn") 
var chicken_scene = preload("res://scenes/mobs/chicken.tscn")

var menu_node

var random = RandomNumberGenerator.new()

var plains_biome = preload("res://resources/biomes/plains.tres")

var chunks = []

func _ready():
    randomize()
    random.seed = randi()
    
    chunks.push_back(self.region_around_player())
    TerrainGenerator.queue_generation(self.region_around_player())

    culling_area.shape.extents = Utils.map_to_world(self.world_size) / 2
    generation_shape.shape.extents = Utils.map_to_world(self.world_size) / 4
    
    ui_container.connect("item_dropped", self, "spawn_dropped_item")
    ui_container.connect("canvas_clicked", player, "try_use_item")

func region_around_player() -> Rect2:
    var top_left = Utils.world_to_map(player.position) - (self.world_size / 2)
    return Rect2(top_left, self.world_size)

func _process(delta):
    if $Debug.is_active():
        $Debug.process_debug(player, delta)
        
    if Input.is_action_just_pressed("ui_cancel"):
        if $UIOverlay.is_displaying():
            $UIOverlay.stop_display()
        else:
            $UIOverlay.display($UIOverlay.Kind.EscapeMenu)

    for i in len(self.chunks):
        var region = TerrainGenerator.get_generated_region(self.chunks[i])
        if region:
            ground.call_deferred("update_terrain", region)
            objects.call_deferred("update_terrain", region)
            self.chunks.remove(i)

func game_over():
    print("player has died")
    get_tree().paused = true

func spawn_dropped_item(item: Item):
    var item_inst = item_scene.instance()
    item_inst.item = item
    var increment = Vector2(25, 25)
    if player.last_direction == Vector2(0, -1):
        increment = Vector2(50, 50)
    item_inst.position = player.position + Vector2(0, 25) + (increment * player.last_direction)
    self.add_child(item_inst)


func _on_body_exit_region(body:Node):
    if body == self.player:
        var region = self.region_around_player()
        TerrainGenerator.queue_generation(region)
        self.chunks.push_back(region)
        self.generation_area.position = self.player.position
