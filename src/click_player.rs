use gdnative::prelude::*;

#[derive(NativeClass, Default)]
#[inherit(KinematicBody2D)]
pub struct ClickPlayer {
    target: Vector2,
    velocity: Vector2,
    speed: f32,
}

#[methods]
impl ClickPlayer {
    pub fn new(owner: &KinematicBody2D) -> Self {
        Self {
            speed: 200.0,
            target: owner.global_position(),
            ..Default::default()
        }
    }

    #[export]
    pub fn _process(&mut self, owner: &KinematicBody2D, delta: f32) {
        self.velocity = (self.target - owner.global_position()).normalize() * self.speed;
        if (self.target - owner.global_position()).length() > 5.0 {
            self.velocity = owner.move_and_slide(
                self.velocity,
                Vector2::default(),
                false,
                4,
                0.785398,
                true,
            );
        }
    }

    #[export]
    pub fn _input(&mut self, owner: &KinematicBody2D, event: Ref<InputEvent>) {
        let event = unsafe { event.assume_safe() };
        if event.is_action_pressed("click", false) {
            let view = owner.get_viewport().unwrap();
            let view = unsafe { view.assume_safe() };
            self.target = view.get_mouse_position();
        }
    }
}