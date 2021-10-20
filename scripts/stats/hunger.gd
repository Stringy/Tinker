extends Stat
class_name Hunger

export (float) var initial_value = 100.0
export (float) var base_depletion_value = 0.5

func deplete(addition: float = 0.0):
	.reduce_value(self.base_depletion_value + addition)
