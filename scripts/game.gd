extends Node

onready var ysort = $YSort
onready var ui_container = $GUI/Container
onready var ui_inventory = $GUI/Container/PlayerBlock/Player/PlayerInventory
onready var ui_stats = $GUI/Container/PlayerBlock/Player/PlayerStats
onready var player = $YSort/Player
onready var terrain = $Terrain
onready var main_camera = $YSort/Player/MainCamera

var item_scene = preload("res://scenes/item.tscn")

func _ready():
    terrain._generate_world(player.position)
    ui_container.connect("item_dropped", self, "spawn_dropped_item")
    ui_container.connect("canvas_clicked", player, "try_use_item")
 
func _process(_delta):
    if $Debug.is_active():
        $Debug.process_debug(terrain, player)

    if Input.is_action_just_pressed("ui_select"):
        self.swap_player()

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
