extends Stat
class_name Hunger

export (float) var initial_value = 100.0
export (float) var base_depletion_value = 0.25
export (float) var addition_scale = 0.002

func deplete(addition: float = 0.0):
	if addition < 0:
		addition = 0
	.reduce_value(self.base_depletion_value + (addition * self.addition_scale))
