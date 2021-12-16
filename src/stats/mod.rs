use gdnative::prelude::*;
use gdnative::api::Resource;

#[derive(NativeClass, Default)]
#[inherit(Resource)]
pub struct Stat {
    value: f64,
    max: f64,
    min: f64,
}

#[methods]
impl Stat {
    pub fn new(owner: &Resource) -> Self {
        Default::default()
    }
}

#[derive(Default)]
pub struct Stats {
    health: Stat,
    thirst: Stat,
    hunger: Stat,
}

impl Stats {
    pub fn new() -> Self {
        Default::default()
    }
    pub fn update(&mut self, delta: f32) {}
}