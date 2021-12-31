extends TileMap


var TILES = {
    'grass': 0,
    'grass_v1': 1,
    'grass_v2': 2,
    'grass_v3': 3
}

func update_terrain(region):
    print("updating ground")
    print(region.transform)
    for y in len(region.tiles):
        var row = region.tiles[y]
        for x in len(row):
            self.set_cellv(Vector2(x, y), row[x])

func generate(region: Rect2, biome: Biome):
    self.tile_set = biome.tile_set

    var position = region.position
    var size = region.size
    
    var x_coord = position.x
    var y_coord = position.y

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
