extends Item
class_name Food

export (float) var calories = 0.0

func _init():
	._init()
	self._consumable = true

func use(actor: Node) -> bool:
	if actor.get("hunger") != null and actor.hunger is Hunger:
		# we can feed this actor
		actor.hunger.increase_value(self.calories)
		return true
	return false
