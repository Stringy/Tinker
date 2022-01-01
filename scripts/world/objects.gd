extends WorldGenerator

var tree = preload("res://scenes/world/tree.tscn")
var grass = preload("res://scenes/world/grass.tscn")

var objects = {}

export (int) var spawn_per_frame = 50

var to_spawn = []

enum Kind {
    Tree,
    Grass
}

func _process(_delta):
    var items_to_spawn = min(self.spawn_per_frame, len(to_spawn))
    for i in items_to_spawn:
        var item = to_spawn.pop_front()
        match item[0]:
            Kind.Tree:
                self.spawn_object(item[1], tree, $Trees)
            Kind.Grass:
                self.spawn_object(item[1], grass, $Grass)
                
func spawn_object(loc, scene, parent):
    var new_obj = scene.instance()
    new_obj.position = Utils.map_to_world(loc)
    new_obj.add_to_group("objects")
    parent.add_child(new_obj)
    self.objects[new_obj.position] = new_obj

func update_terrain(region):
    for tree_location in region.trees:
        if objects.has(Utils.map_to_world(tree_location)):
            continue
        to_spawn.push_back([Kind.Tree, tree_location])
    
    for grass_location in region.grass:
        if objects.has(Utils.map_to_world(grass_location)):
            continue
        
        to_spawn.push_back([Kind.Grass, grass_location])

func _on_CullingRange_body_exited(body):
    if body.is_in_group("objects"):
        self.objects.erase(body.position)
        body.queue_free()

func _on_CullingRange_area_exited(area):
    if area.is_in_group("objects"):
        self.objects.erase(area.position)
        area.queue_free()
