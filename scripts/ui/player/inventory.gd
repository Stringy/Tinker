extends CenterContainer

var inventory: Inventory

onready var slots = $SlotContainer

func _ready():
    var players = get_tree().get_nodes_in_group("players")
    assert(len(players) == 1)
    inventory = players[0].get_inventory()

    inventory.connect("item_added", self, "add_item")
    inventory.connect("item_removed", self, "remove_item")
    inventory.connect("item_swapped", self, "swap_items")
    
    for i in slots.get_child_count():
        var slot = slots.get_child(i)
        var item = inventory.get_item(i)
        slot.display(item)
        
    slots.get_child(self.inventory.get_selected_slot()).toggle_selected()
    
func _input(event):
    for i in 10:
        if event.is_action_pressed("select_hotbar_" + str(i + 1)):
            slots.get_child(self.inventory.get_selected_slot()).toggle_selected()
            slots.get_child(i).toggle_selected()
            self.inventory.set_selected_slot(i)
            break
    
func add_item(idx):
    self.update_slot(idx, inventory.get_item(idx))
    
func remove_item(idx):
    self.update_slot(idx, null)
    
func swap_items(from_idx, to_idx):
    var from = inventory.get_item(from_idx)
    var to = inventory.get_item(to_idx)
    self.update_slot(from_idx, from)
    self.update_slot(to_idx, to)
        
func update_slot(idx, item):
    var slot = slots.get_child(idx)
    slot.display(item)
