extends Resource
class_name Biome

export (OpenSimplexNoise) var noise;
export (TileSet) var tile_set;
export (TileSet) var trees;
export (float) var tree_weight;

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
