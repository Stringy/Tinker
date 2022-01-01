extends Resource
class_name Biome

export (OpenSimplexNoise) var noise;
export (TileSet) var tile_set;
export (PackedScene) var tree;
export (float, -1.0, 1.0) var tree_weight;
export (bool) var has_grass = true;
export (float, -1.0, 1.0) var grass_weight;
export (PackedScene) var grass

func get_tile_idx(x: float, y: float) -> int:
    var ids = self.tile_set.get_tiles_ids()
    var sample = self.noise.get_noise_2d(x, y)
    if sample < -0.3:
        return ids[0]
    if sample < -0.1:
        return ids[1]
    if sample < 0.3:
        return ids[2]
    return ids[3]
    
func should_place_tree(x: float, y: float) -> bool:
    return self.noise.get_noise_2d(x, y) < self.tree_weight

func should_place_grass(x: float, y: float) -> bool:
    if not self.has_grass:
        return false
    return self.noise.get_noise_2d(x, y) < self.grass_weight
    
