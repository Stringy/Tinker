tool
extends Node2D

#
#var ground_noise
#var object_noise

# the seed for the opensimplexnoise.
# TODO: make it random
export (int) var noise_seed = 250

# the width/height of the terrain (in tiles)
export (Vector2) var size = Vector2(256, 256)

# the size of the border (in tiles)
export (Vector2) var border = Vector2(32, 32)

export (OpenSimplexNoise) var ground_noise
export (OpenSimplexNoise) var object_noise

# These are used to store the computed internal
# rectangle to trigger further terrain generation
var top_left
var bounds = Rect2()

func _ready():
	randomize()
	ground_noise.seed = randi()
	object_noise.seed = randi()

	top_left = self.position - (self.size / 2) + self.border
	bounds = Rect2(top_left, self.size - (self.border * 2))
	$Ground.generate(ground_noise, self.position, self.size)
	$Objects.generate(object_noise, self.position, self.size)

func _generate_world(position: Vector2):
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
		$Ground.generate(ground_noise, position, self.size)
		$Objects.generate(object_noise, position, self.size)
		top_left = center - (self.size / 2) + self.border
		bounds = Rect2(top_left, self.size - (self.border * 2))

func world_to_map(position: Vector2):
	return $Ground.world_to_map(position)
