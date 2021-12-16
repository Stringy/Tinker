extern crate gdnative;
extern crate num;

use gdnative::prelude::*;

pub mod terrain;
pub mod player;
pub mod utils;
pub mod stats;

fn init(handle: InitHandle) {
    terrain::init(&handle);
    player::init(&handle);
    utils::init(&handle);
}

godot_init!(init);