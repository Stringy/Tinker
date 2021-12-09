extends Control

signal item_dropped(item)
signal canvas_clicked(position)

func can_drop_data(_position, data):
    return data is Dictionary and data.has("item")
    
func drop_data(_position, data):
    emit_signal("item_dropped", data.item)
    
func _gui_input(event):
    if event.is_action_pressed('click'):
        emit_signal("canvas_clicked", event.position)


