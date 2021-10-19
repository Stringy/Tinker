extends CanvasLayer

var hunger = 100 setget set_hunger

func set_hunger(h):
	hunger = h
	$Container/Player/Stats/Hunger.text = "Hunger: " + str(self.hunger)

var thirst = 100 setget set_thirst

func set_thirst(h):
	thirst = h
	$Container/Player/Stats/Thirst.text = "Thirst: " + str(thirst)

var health = 100 setget set_health

func set_health(h):
	health = h
	$Container/Player/Stats/Health.text = "Health: " + str(health)

