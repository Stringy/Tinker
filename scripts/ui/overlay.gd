extends CanvasLayer

var current_menu: Node = null

var escape_menu = preload("res://scenes/ui/esc_menu.tscn")

enum Kind {
    EscapeMenu,
}

func _ready():
    $BlurBackground.visible = false

func display(kind):
    var new_menu: PackedScene
    match kind:
        Kind.EscapeMenu:
            new_menu = escape_menu
        _:
            return ERR_UNAVAILABLE
    
    $BlurBackground.visible = true

    if current_menu != null:
        self.remove_child(current_menu)

    var new_menu_scene = new_menu.instance()
    self.add_child(new_menu_scene)
    current_menu = new_menu_scene
    return OK
    
func stop_display():
    if current_menu != null:
        self.remove_child(current_menu)
        current_menu = null
    
    $BlurBackground.visible = false

func is_displaying():
    return $BlurBackground.visible