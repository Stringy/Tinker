extends TileMap


var TILES = {
    'grass': 0,
    'grass_v1': 1,
    'grass_v2': 2,
    'grass_v3': 3
}

func generate(region: Rect2, biome: Biome):
    self.tile_set = biome.tile_set

    print(region.position)
    print(region.size)

    var position = self.world_to_map(region.position)
    var size = self.world_to_map(region.size)

    var x_coord = position.x - (size.x / 2)
    var y_coord = position.y - (size.y / 2)

    for y in size.y:
        for x in size.x:
            self.set_cellv(
                Vector2(x_coord + x, y_coord + y),
                _get_tile_index(biome.noise.get_noise_2d(float(x_coord + x), float(y_coord + y)), biome)
            )

func _get_tile_index(sample: float, biome: Biome):
    var ids = biome.tile_set.get_tiles_ids()
    if sample < -0.3:
        return ids[0]
    if sample < -0.1:
        return ids[1]
    if sample < 0.3:
        return ids[2]
    return ids[3]
