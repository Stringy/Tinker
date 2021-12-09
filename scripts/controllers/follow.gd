extends Controller

export (NodePath) var leaderPath
export (float) var distance_behind = 50.0
export (float) var slowing_radius = 40.0

# onready var leader = get_node(leaderPath)

func arrive(target: Vector2):
    var desired = target - self.global_position

    var distance = desired.length()
    
    if distance < slowing_radius:
        desired = desired.normalized() * self.speed * (distance / slowing_radius)
    else:
        desired = desired.normalized() * self.speed
        
    var force = desired - self.get_velocity()
    return force
    
func get_target() -> Vector2:
    var leader = get_node(leaderPath)
    var tv = leader.get_velocity() * -1
    return leader.global_position + (tv.normalized() * distance_behind)

func calculate_movement() -> Vector2:
    var behind = get_target()
    return arrive(behind)
