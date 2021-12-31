extends WorldGenerator

var tree = preload("res://scenes/world/tree.tscn")
var grass = preload("res://scenes/world/grass.tscn")

var objects = {}

func update_terrain(region):
    for tree_location in region.trees:
        if objects.has(Utils.map_to_world(tree_location)):
            continue
            
        var new_tree = tree.instance()
        new_tree.position = Utils.map_to_world(tree_location)
        new_tree.add_to_group("objects")
        $Trees.add_child(new_tree)
        self.objects[new_tree.position] = new_tree
    
    for grass_location in region.grass:
        if objects.has(Utils.map_to_world(grass_location)):
            continue
        
        var new_grass = grass.instance()
        new_grass.position = Utils.map_to_world(grass_location)
        new_grass.add_to_group("objects")
        $Grass.add_child(new_grass)
        self.objects[new_grass.position] = new_grass


func _on_CullingRange_body_exited(body):
    if body.is_in_group("objects"):
        self.objects.erase(body.position)
        body.queue_free()


func _on_CullingRange_area_exited(area):
    if area.is_in_group("objects"):
        self.objects.erase(area.position)
        area.queue_free()
