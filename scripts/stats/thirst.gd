extends Stat
class_name Thirst

export (float) var initial_value = 100.0
export (float) var base_depletion_value = 0.5
export (float) var addition_scale = 0.002

func deplete(addition: float = 0.0):
	.reduce_value(self.base_depletion_value + (addition * self.addition_scale))
