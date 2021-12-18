extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


var TILES = {
    'empty': -1,
    'long_grass_1': 0,
    'long_grass_2': 1,
    'long_grass_3': 2,
}

var TREES = range(3, 7)

func generate(noise, position, size):
    position = self.world_to_map(position)

    var x_coord = position.x - (size.x / 2)
    var y_coord = position.y - (size.y / 2)

    for y in size.y:
        for x in size.x:
            self.set_cellv(
                Vector2(x_coord + x, y_coord + y),
                _get_tile_index(noise.get_noise_2d(float(x_coord + x), float(y_coord + y)))
            )

func _get_tile_index(sample):
    if sample < -0.8:
        return TILES.long_grass_1
    if sample < -0.6:
        return TILES.long_grass_2
    if sample < -0.4:
        return TILES.long_grass_3
    if sample < -0.35:
        return TREES[randi() % len(TREES)]
    return TILES.empty
