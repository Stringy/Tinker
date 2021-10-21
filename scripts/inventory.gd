extends Resource
class_name Inventory

signal item_added(index)
signal item_removed(index)
signal item_swapped(from_idx, to_idx)

export (int) var size = 10

var items = []

func _init():
	for i in size:
		items.append(null)

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
	
func swap_items(from_idx, to_idx):
	var from  = get_item(from_idx)
	var to = get_item(to_idx)
	items[from_idx] = to
	items[to_idx] = from
	emit_signal("item_swapped", from_idx, to_idx)
