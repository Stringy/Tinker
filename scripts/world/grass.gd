extends Node2D

enum GrassKind {
    A,
    B,
    C,
    D    
}

onready var sprite: Sprite = $Sprite

export (GrassKind) var kind = GrassKind.A

func _ready():
    var rand = RandomNumberGenerator.new()
    rand.seed = hash(self.position)
    self.kind = GrassKind.values()[rand.randi() % len(GrassKind.values())]
    
    var x
    var y
    match self.kind:
        GrassKind.A:
            x = 0
            y = 0
        GrassKind.B:
            x = 32
            y = 0
        GrassKind.C:
            x = 0
            y = 32
        GrassKind.D:
            x = 32
            y = 32
    sprite.region_rect.position.x += x
    sprite.region_rect.position.y += y

func _to_string():
    return "Grass(@" + str(self.position) + ")"
