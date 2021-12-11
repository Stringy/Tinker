extends Node

onready var ui_container = $GUI/Container
onready var player = $Player
onready var terrain = $Terrain

var item_scene = preload("res://scenes/item.tscn")

var npc_scene = preload("res://scenes/npc.tscn")

func _ready():
    terrain._generate_world($Player.position)
    ui_container.connect("item_dropped", self, "spawn_dropped_item")
    ui_container.connect("canvas_clicked", player, "try_use_item")
 
func _process(_delta):
    if $Debug.is_active():
        $Debug.process_debug(terrain, player)

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
