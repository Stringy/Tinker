mod click_player;
mod terrain;

use gdnative::prelude::*;
use crate::click_player::ClickPlayer;
use crate::terrain::TerrainMesh;

/// The HelloWorld "class"
#[derive(NativeClass)]
#[inherit(Sprite)]
pub struct Player {
    pub speed: f32,
}

#[methods]
impl Player {
    pub fn new(_owner: &Sprite) -> Self {
        Self {
            speed: 200.0
        }
    }

    #[export]
    pub fn _ready(&self, _owner: &Sprite) {
        godot_print!("hello, player!");
    }

    #[export]
    pub fn _physics_process(&mut self, owner: &Sprite, delta: f32) {
        let input = Input::godot_singleton();
        let view = owner.get_viewport().unwrap();
        let view = unsafe { view.assume_safe() };
        let mouse = view.get_mouse_position();

        let direction = (mouse - owner.global_position()).normalize();

        if Input::is_action_pressed(input, "forward") {
            owner.set_global_position(
                owner.global_position() + (direction * self.speed * delta)
            )
        }

        owner.look_at(mouse);
    }
}

// Function that registers all exposed classes to Godot
fn init(handle: InitHandle) {
    handle.add_class::<Player>();
    handle.add_class::<ClickPlayer>();
    handle.add_class::<TerrainMesh>();
}

// Macro that creates the entry-points of the dynamic library.
godot_init!(init);