use gdnative::prelude::*;
use gdnative::api::TileMap;
use gdnative::api::OpenSimplexNoise;

use crate::terrain::Terrain;

#[derive(NativeClass)]
#[inherit(TileMap)]
pub struct Ground;

#[methods]
impl Ground {
    pub fn new(_owner: &TileMap) -> Self {
        Ground
    }

    #[export]
    pub fn generate(&self, owner: &TileMap, noise: Ref<OpenSimplexNoise>, position: Vector2, size: Vector2) {
        self.generate_area(owner, noise, position, size)
    }
}

impl Terrain for Ground {
    fn get_tile_index(&self, sample: f64) -> i64 {
        match sample {
            x if x < -0.3 => 0,
            x if x < -0.1 => 1,
            x if x < 0.3 => 2,
            _ => 3
        }
    }
}