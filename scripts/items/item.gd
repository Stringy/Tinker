extends Resource
class_name Item

export (String) var name
export (Texture) var texture

var _consumable setget , consumable

func _init():
	self._consumable = false

func use(actor: Node) -> bool:
	return false

func consumable() -> bool:
	return _consumable
