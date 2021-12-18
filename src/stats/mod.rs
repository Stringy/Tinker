use gdnative::prelude::*;
use gdnative::api::Resource;

pub enum StatKind {
    Health,
    Thirst,
    Hunger,
}

#[derive(NativeClass)]
#[inherit(Resource)]
#[no_constructor]
pub struct Stat {
    kind: StatKind,
    value: f64,
    max: f64,
    min: f64,
}

#[methods]
impl Stat {}

pub struct Stats {
    health: Stat,
    thirst: Stat,
    hunger: Stat,
}

impl Stats {
    pub fn new() -> Self {
        Stats {
            health: Stat {
                kind: StatKind::Health,
                value: 100.0,
                max: 100.0,
                min: 100.0,
            },
            thirst: Stat {
                kind: StatKind::Thirst,
                value: 100.0,
                max: 100.0,
                min: 100.0,
            },
            hunger: Stat {
                kind: StatKind::Hunger,
                value: 100.0,
                max: 100.0,
                min: 100.0,
            },
        }
    }
    pub fn update(&mut self, delta: f32) {}
}