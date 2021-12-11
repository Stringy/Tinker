extends AnimationPlayer

func animate_direction(direction: Vector2, action: String):
    var new_direction = Utils.get_animation_direction(direction)   
    var animation = new_direction + "_" + action
    self.play(animation)
    return animation
