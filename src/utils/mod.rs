use gdnative::prelude::*;
use gdnative::api::AnimationPlayer;

#[derive(NativeClass)]
#[inherit(AnimationPlayer)]
pub struct DirectionalSprite;

#[methods]
impl DirectionalSprite {
    pub fn new(_owner: &AnimationPlayer) -> Self {
        DirectionalSprite
    }

    pub fn animate_direction(&self, owner: &AnimationPlayer, direction: Vector2, action: &'static str) -> String {
        let dir_name = get_animation_direction(direction);
        let animation = dir_name + "_" + action;
        owner.play(animation.clone(), -1.0, 1.0, false);
        return animation;
    }
}

fn get_animation_direction(direction: Vector2) -> String {
    let norm = direction.normalized();
    if norm.y >= 0.707 {
        "down"
    } else if norm.y <= -0.707 {
        "up"
    } else if norm.x <= -0.707 {
        "left"
    } else if norm.x >= 0.707 {
        "right"
    } else {
        "down"
    }.into()
}

pub fn init(handle: &InitHandle) {
    handle.add_class::<DirectionalSprite>();
}