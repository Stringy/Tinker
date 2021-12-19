tool
extends Node2D

enum TreeType {
	Plain = 0,
	GreenFruit = 1,
	LeafyFruit = 2,
	RipeFruit = 3,
	Harvested = 4,
}

export (TreeType) var kind = TreeType.Plain

onready var sprite: Sprite = $Sprite

func _ready():
	sprite.region_rect.position.x += 32 * self.kind * 3
