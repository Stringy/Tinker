extends TileMap


var TILES = {
	'grass': 0,
	'grass_v1': 1,
	'grass_v2': 2,
	'grass_v3': 3
}

func generate(noise, position, width, height):
	position = self.world_to_map(position)

	var x_coord = position.x - (width / 2)
	var y_coord = position.y - (height / 2)

	for y in height:
		for x in width:
			self.set_cellv(
				Vector2(x_coord + x, y_coord + y),
				_get_tile_index(noise.get_noise_2d(float(x_coord + x), float(y_coord + y)))
			)

func _get_tile_index(sample):
	if sample < -0.3:
		return TILES.grass
	if sample < -0.1:
		return TILES.grass_v1
	if sample < 0.3:
		return TILES.grass_v2
	return TILES.grass_v3
