extends AnimatedSprite

func animate_direction(direction: Vector2, action: String):
	var new_direction = Utils.get_animation_direction(direction)
	
	self.flip_h = new_direction == "right"
	
	if new_direction == "left" or new_direction == "right":
		new_direction = "side"
	
	animation = new_direction + "_" + action
	self.play(animation)
	return animation
