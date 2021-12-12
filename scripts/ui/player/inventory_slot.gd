extends CenterContainer

var inventory = preload("res://resources/player/inventory.tres")

var frame_tex = preload("res://sprites/ui/inventory_frame.png")
var frame_in_use_tex = preload("res://sprites/ui/inventory_frame_inuse.png")
var selected = false

onready var texture = $Texture

func _ready():
    var player = Utils.get_player()
    inventory = player.get_inventory()

func display(item: Item):
    if item != null:
        texture.texture = item.texture
    else:
        texture.texture = null
        
func toggle_selected():
    selected = !selected
    if selected:
        $Frame.texture = frame_in_use_tex
    else:
        $Frame.texture = frame_tex
        

func get_drag_data(_position):
    var idx = get_index()
    var item = inventory.pop_item(idx)
    if not item:
        return null
    var data = {
        'item': item,
        'idx': idx
    }
    var drag_preview = TextureRect.new()
    drag_preview.texture = item.texture
    set_drag_preview(drag_preview)
    inventory.drag_data = data
    return data
    
func drop_data(_position, data):
    var idx = get_index()
    var item = inventory.get_item(idx)
    if item:
        inventory.set_item(data.item, idx)
        inventory.set_item(item, data.idx)
    else:
        inventory.set_item(data.item, idx)
    inventory.drag_data = null
        
func can_drop_data(_position, data):
    return data is Dictionary and data.has("item")

