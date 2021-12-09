extends Node

export (Resource) var item

func _ready():
    randomize()
    $Sprite.texture = item.texture
    var offs = rand_range(0, $AnimationPlayer.current_animation_length)
    $AnimationPlayer.advance(offs)

func _on_body_entered(body):
    if body.is_in_group('players'):
        var inventory: Inventory = body.get_inventory()
        var slot = inventory.get_empty_slot()
        if slot >= 0:
            inventory.set_item(item, slot)
            self.queue_free()

