use std::f64::consts::FRAC_PI_4;
use std::ops::Mul;
use gdnative::prelude::*;
use gdnative::api::KinematicBody2D;
use gdnative::api::Input;

use crate::utils::DirectionalSprite;
use crate::stats::Stats;

#[derive(NativeClass)]
#[inherit(KinematicBody2D)]
pub struct Player {
    velocity: Vector2,
    frames_moved: f32,
    attacking: bool,
    stats: Stats,

    #[property(default = 200.0)]
    speed: f32,
    #[property(default = false)]
    is_player: bool,
}

#[methods]
impl Player {
    pub fn new(_owner: &KinematicBody2D) -> Self {
        Player {
            velocity: Vector2::ZERO,
            frames_moved: 0.0,
            attacking: false,
            stats: Stats::new(),
            speed: 200.0,
            is_player: false,
        }
    }

    pub fn register_signals(builder: &ClassBuilder<Self>) {
        builder.add_signal(Signal {
            name: "stat_changed",
            args: &[],
        });

        builder.add_signal(Signal {
            name: "moved",
            args: &[],
        });

        builder.add_signal(Signal {
            name: "is_player",
            args: &[],
        });

        builder.add_signal(Signal {
            name: "is_not_player",
            args: &[],
        });
    }

    #[export]
    pub fn _physics_process(&mut self, owner: &KinematicBody2D, _delta: f64) {
        let direction = if self.is_player {
            let input = Input::godot_singleton();
            let mut direction = Vector2::ZERO;
            if Input::is_action_pressed(input, "forward", false) {
                direction.y -= 1.0;
            }
            if Input::is_action_pressed(input, "backward", false) {
                direction.y -= 1.0;
            }
            if Input::is_action_pressed(input, "left", false) {
                direction.y -= 1.0;
            }
            if Input::is_action_pressed(input, "right", false) {
                direction.y -= 1.0;
            }

            direction.mul(self.speed)
        } else {
            Vector2::ZERO
        };

        self.do_move(owner, direction);
    }
}

impl Player {
    fn do_move(&mut self, owner: &KinematicBody2D, velocity: Vector2) {
        if self.attacking {
            return;
        }

        self.animate(owner, velocity);
        self.update_moved_frames(velocity);

        if velocity != Vector2::ZERO {
            self.velocity = owner.move_and_slide(
                velocity,
                Vector2::ZERO,
                false,
                4,
                FRAC_PI_4,
                true,
            );

            owner.emit_signal("moved", &[Variant::new(owner.position())]);
        }
    }

    fn animate(&mut self, owner: &KinematicBody2D, velocity: Vector2) {
        let sprites = unsafe {
            owner.get_node_as_instance::<DirectionalSprite>("AnimationPlayer").unwrap()
        };
        if velocity != Vector2::ZERO {
            sprites.map(|ds, owner| {
                ds.animate_direction(&owner, velocity, "walk")
            }).unwrap();
        } else {
            sprites.map(|ds, owner| {
                ds.animate_direction(&owner, self.velocity, "idle")
            }).unwrap();
        }
    }

    fn update_moved_frames(&mut self, velocity: Vector2) {
        if velocity != Vector2::ZERO {
            self.frames_moved += 1.0;
        } else {
            self.frames_moved -= 1.0;
        }

        self.frames_moved = num::clamp(self.frames_moved, 0.0, 100.0);
    }

    fn on_stats_timeout(&mut self) {
        // TODO(giles): still not a percentage
        let percent_moved = num::clamp(self.frames_moved, 0.0, 100.0);
        self.stats.update(percent_moved);
    }

    fn on_animation_finished(&mut self, owner: &KinematicBody2D, name: Variant) {
        self.attacking = false;
        let sprites = unsafe {
            owner.get_node_as_instance::<DirectionalSprite>("AnimationPlayer").unwrap()
        };
        sprites.map(|ds, owner| {
            ds.animate_direction(&owner, Vector2::ZERO, "idle")
        }).unwrap();
    }

    fn on_melee_attack_hits(&self, owner: &KinematicBody2D, body: &mut Variant) {
        unsafe { body.call("hit", &[Variant::new(25)]) }.unwrap();
    }
}

pub fn init(handle: &InitHandle) {
    handle.add_class::<Player>();
}