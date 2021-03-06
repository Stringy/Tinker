extends Node

func get_animation_direction(direction: Vector2):
    var norm_direction = direction.normalized()
    if norm_direction.y >= 0.707:
        return "down"
    elif norm_direction.y <= -0.707:
        return "up"
    elif norm_direction.x <= -0.707:
        return "left"
    elif norm_direction.x >= 0.707:
        return "right"
    return "down"
    
func should_update(last_update: float, interval: float):
    return OS.get_ticks_msec() - (interval * 1000) >= last_update

func weighted_result(weights: Dictionary) -> float:
    var max_key
    var max_value = 0.0
    for key in weights.keys():
        var result = randf() * weights[key]
        if result > max_value:
            max_key = key
            max_value = result
    return max_key
    
func copy(value):
    var type = typeof(value)
    
    if type == TYPE_OBJECT and value.has_method('duplicate'):
        return value.duplicate(true)
    
    if type == TYPE_DICTIONARY:
        return value.duplicate(true)
    
    if type == TYPE_ARRAY:
        return value.duplicate(true)
        
    return value
    
#
# Gets the current player (only member of the players group)
# TODO(eventually): multiplayer?
#
func get_player():
    var players = get_tree().get_nodes_in_group("players")
    assert(len(players) == 1)
    return players[0]

#
# Converts a world position to a map coordinate
#
func world_to_map(position: Vector2, cell_size: Vector2 = Vector2(32, 32)):
    return (position / cell_size).floor()

#
# Converts a map coordinate to a world position
#
func map_to_world(position: Vector2, cell_size: Vector2 = Vector2(32, 32)):
    return position * cell_size
