extends WorldGenerator

var tree = preload("res://scenes/world/tree.tscn")

var spawned_trees = {}

func update_terrain(region):
    for tree_location in region.trees:
        if spawned_trees.has(Utils.map_to_world(tree_location)):
            continue
            
        var new_tree = tree.instance()
        new_tree.position = Utils.map_to_world(tree_location)
        new_tree.add_to_group("objects")
        $Trees.add_child(new_tree)
        self.spawned_trees[new_tree.position] = new_tree


func _on_CullingRange_body_exited(body):
    if body.is_in_group("objects"):
        self.spawned_trees.erase(body.position)
        body.queue_free()
