extends TileMap


var TILES = {
    'grass': 0,
    'grass_v1': 1,
    'grass_v2': 2,
    'grass_v3': 3
}

func update_terrain(region):
    for y in len(region.tiles):
        var row = region.tiles[y]
        for x in len(row):
            self.set_cellv(Vector2(x, y) + region.transform.position, row[x])
    
