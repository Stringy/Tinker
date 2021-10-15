extends Node2D


var noise

# the seed for the opensimplexnoise.
# TODO: make it random
export (int) var noise_seed = 250

# the width/height of the terrain (in tiles)
export (Vector2) var size = Vector2(256, 256)

# the size of the border (in tiles)
export (Vector2) var border = Vector2(32, 32)

# These are used to store the computed internal
# rectangle to trigger further terrain generation
var top_left
var bounds = Rect2()

func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = noise_seed
	noise.octaves = 4
	noise.period = 15
	noise.lacunarity = 1.5
	noise.persistence = 0.75
	
	top_left = self.position - (self.size / 2) + self.border
	bounds = Rect2(top_left, self.size - self.border)
	$Ground.generate(noise, self.position, self.size.x, self.size.y)

func _generate_world(position):
	#
	# If you consider the generated terrain to be a rectangle,
	# we compute an concentric rectangle to decide whether the position is
	# getting close to an edge, so we need to generate some more terrain.
	#
	# If the position is outside the inner box, then we generate a new
	# rectangle of generated terrain around the position, and update the
	# border accordingly.
	#
	var center = $Ground.world_to_map(position)
	if not self.bounds.has_point(center):
		$Ground.generate(noise, position, self.size.x, self.size.y)
		top_left = center - (self.size / 2) + self.border
		bounds = Rect2(top_left, self.size - self.border)

