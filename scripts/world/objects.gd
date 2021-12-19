extends WorldGenerator

var tree = preload("res://scenes/world/tree.tscn")


func generate(region: Rect2, biome: Biome):
    self._generate_trees(region, biome)


func _generate_trees(region: Rect2, biome: Biome):
    var step = 32
    for y in region.size.y:
        for x in region.size.x:
            x = (region.position.x + x) * step
            y = (region.position.y + y) * step

            if biome.noise.get_noise_2d(x, y) < (-0.5 * biome.tree_weight):
                var new_tree = tree.instance()
                new_tree.position = Vector2(x, y)
                $Trees.add_child(new_tree)