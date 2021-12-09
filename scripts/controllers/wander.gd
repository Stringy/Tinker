extends Controller

var wanderAngle = 0.0
var last_update = OS.get_ticks_msec()

export (float) var wanderSeconds = 0.2
export (float) var ring_distance = 150;
export (float) var ring_radius = 50;
export (float) var angle_change = 0.5;

func _ready():
	randomize()
	self.velocity = set_angle(self.velocity, randf()).normalized() * self.speed

func set_angle(vector: Vector2, angle: float):
	var length = vector.length()
	vector.x = cos(angle) * length
	vector.y = sin(angle) * length
	return vector
	
func _wander():
	var circle = self.velocity.normalized() * ring_distance
	var displacement = Vector2(0, -1) * ring_radius
	displacement = set_angle(displacement, wanderAngle)
	wanderAngle += (randf() * angle_change) - (angle_change * 0.5)
	return circle + displacement

func calculate_movement():
	if OS.get_ticks_msec() - (wanderSeconds * 1000) < last_update:
		return self.velocity
	self.velocity = self._wander().normalized() * self.speed
	return self.velocity
