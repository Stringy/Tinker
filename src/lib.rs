extern crate gdnative;

use gdnative::prelude::*;

pub mod terrain;

fn init(handle: InitHandle) {
    terrain::init(&handle);
}

godot_init!(init);