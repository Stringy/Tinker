extends Resource
class_name Inventory

signal item_added(index)
signal item_removed(index)
signal item_swapped(from_idx, to_idx)

export (int) var size = 10

var items = []
var selected_slot setget set_selected_slot, get_selected_slot
var drag_data = null


func _init():
	self.selected_slot = 0
	for i in size:
		self.items.append(null)

func set_item(item, idx):
	items[idx] = item
	emit_signal("item_added", idx)
	
func get_item(idx):
	return items[idx]
	
func slot_used(idx):
	return items[idx] != null
	
func has_space():
	return items.has(null)
	
func remove_item(idx):
	items[idx] = null
	emit_signal("item_removed", idx)
	
func pop_item(idx):
	var item = items[idx]
	items[idx] = null
	emit_signal("item_removed", idx)
	return item
	
func swap_items(from_idx, to_idx):
	var from  = get_item(from_idx)
	var to = get_item(to_idx)
	items[from_idx] = to
	items[to_idx] = from
	emit_signal("item_swapped", from_idx, to_idx)
	
func get_empty_slot() -> int:
	for i in self.items.size():
		if self.items[i] == null:
			return i
	return -1

func get_selected_slot() -> int:
	return selected_slot
	
func set_selected_slot(slot: int):
	selected_slot = slot % self.size

func get_selected_item() -> Item:
	return self.items[self.selected_slot]
	
func remove_selected_item():
	self.remove_item(self.selected_slot)
