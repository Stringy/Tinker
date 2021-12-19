extends Node

onready var world = $World
onready var ui_container = $GUI/Container
onready var ui_inventory = $GUI/Container/PlayerBlock/Player/PlayerInventory
onready var ui_stats = $GUI/Container/PlayerBlock/Player/PlayerStats
onready var player = $World/Player
onready var terrain = $Terrain
onready var objects = $World/Objects
onready var main_camera = $World/Player/MainCamera

export (Vector2) var world_size = Vector2(64, 64)
export (Vector2) var generation_border = Vector2(16, 16)
var bounds = Rect2()

var item_scene = preload("res://scenes/item.tscn") 
var chicken_scene = preload("res://scenes/mobs/chicken.tscn")

var random = RandomNumberGenerator.new()

var plains_biome = preload("res://resources/biomes/plains.tres")

func _ready():
    randomize()
    random.seed = randi()
    terrain.generate(region_around_player(), plains_biome)
    objects.generate(region_around_player(), plains_biome)

    player.connect("moved", self, "generate_world")
    
    var top_left = player.position - (self.world_size / 2) + self.generation_border
    self.bounds = Rect2(terrain.world_to_map(top_left), self.world_size - (self.generation_border * 2))

    ui_container.connect("item_dropped", self, "spawn_dropped_item")
    ui_container.connect("canvas_clicked", player, "try_use_item")

func region_around_player() -> Rect2:
    var top_left = terrain.world_to_map(player.position - (self.world_size / 2) + self.generation_border)
    return Rect2(top_left, self.world_size)

func generate_world(position: Vector2):
    var center = terrain.world_to_map(position)
    if not self.bounds.has_point(center):
        var region = self.region_around_player()
        terrain.generate(region, plains_biome)
        objects.generate(region, plains_biome)
        self.bounds = Rect2(region.position, self.world_size - (self.generation_border * 2))

func _process(_delta):
    if $Debug.is_active():
        $Debug.process_debug(terrain, player)

    if Input.is_action_just_pressed("ui_select"):
        self.swap_player()

    # if randf() < 0.05:
    #     var chicken = chicken_scene.instance()
    #     chicken.controller = Wander.new()

    #     var view = get_viewport().get_visible_rect().size
    #     var x = random.randf_range(-view.x, view.x)
    #     var y = random.randf_range(-view.y, view.y)

    #     if x < 0:
    #         x -= view.x
    #     else:
    #         x += view.x
        
    #     if y < 0:
    #         y -= view.y
    #     else:
    #         y += view.y

    #     chicken.position = player.position + Vector2(x, y)

    #     world.add_child(chicken)

func swap_player():
    var family = get_tree().get_nodes_in_group("family")

    var other = null
    for person in family:
        if person != player:
            other = person
            break

    if not other:
        print("no other to find... can't swap with player")
        return
    
    player.remove_child(main_camera)
    other.add_child(main_camera)
    
    other.toggle_is_player()
    player.toggle_is_player()

    ui_container.disconnect("canvas_clicked", player, "try_use_item")
    player = other
    ui_container.connect("canvas_clicked", player, "try_use_item")
    player.connect("moved", terrain, "_generate_world")


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
