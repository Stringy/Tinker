extends WorldGenerator

var tree = preload("res://scenes/world/tree.tscn")

var spawned_trees = {}

func generate(region: Rect2, biome: Biome):
    self._generate_trees(region, biome)


func _generate_trees(region: Rect2, biome: Biome):
    var step = 32
    print("tree weight: ", -0.9 * biome.tree_weight)
    print(biome.tree_weight)
    for y in region.size.y:
        for x in region.size.x:     
            var x_global = (region.position.x * step) + (x * step)
            var y_global = (region.position.y * step) + (y * step)
            
            var pos = Vector2(x_global, y_global)
            
            if spawned_trees.has(pos):
                continue
            
            if not biome.noise.get_noise_2d(x_global, y_global) < biome.tree_weight:
                continue

            var new_tree = tree.instance()
            new_tree.position = pos
            $Trees.add_child(new_tree)
            spawned_trees[pos] = tree
