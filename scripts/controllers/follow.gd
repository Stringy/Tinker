extends Controller

export (NodePath) var leaderPath
export (float) var distance_behind = 75.0
export (float) var slowing_radius = 40.0
export (float) var stopping_distance = 75.0
export (float) var separation_distance = 75.0
export (float) var max_separation = 50.0


func distance(other: Node) -> float:
    return self.global_position.distance_to(other.global_position)

func separation():
    var neighbours = 0
    var force = Vector2()
    
    var others = get_tree().get_nodes_in_group(leaderPath)
    for other in others:
        if other != self and distance(other) <= separation_distance:
            force += Vector2(
                other.global_position.x - self.global_position.x,
                other.global_position.y - self.global_position.y
            )
            neighbours += 1
    
    if neighbours != 0:
        force /= Vector2(neighbours, neighbours)
        force *= -1
    
    force = force.normalized() * max_separation
    return force

func arrive(target: Vector2):
    var desired = target - self.global_position

    var distance = desired.length()
    
    if distance < slowing_radius:
        desired = desired.normalized() * self.speed * (distance / slowing_radius)
    else:
        desired = desired.normalized() * self.speed
        
    var force = desired - self.get_velocity()
    force += separation()
    
    if force.abs().length() < stopping_distance:
        force = Vector2.ZERO
    
    return force
    
func get_target() -> Vector2:
    var leader = get_node(leaderPath)
    if not leader:
        return Vector2.ZERO
    
    var tv = Vector2.ZERO
    if leader.has_method('get_velocity'):
        tv = leader.get_velocity() * -1
    return leader.global_position + (tv.normalized() * distance_behind)

func calculate_movement() -> Vector2:
    var behind = get_target()
    return arrive(behind)
