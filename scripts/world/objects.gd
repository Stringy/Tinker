extends WorldGenerator

var tree = preload("res://scenes/world/tree.tscn")

var spawned_trees = {}

func update_terrain(region):
    for tree_location in region.trees:
        if spawned_trees.has(tree_location):
            continue
            
        var new_tree = tree.instance()
        new_tree.position = Utils.map_to_world(tree_location)
        $Trees.add_child(new_tree)
