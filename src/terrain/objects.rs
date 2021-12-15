use gdnative::prelude::*;
use gdnative::api::TileMap;
use gdnative::api::OpenSimplexNoise;

use crate::terrain::Terrain;

#[derive(NativeClass)]
#[inherit(TileMap)]
pub struct TerrainObjects;

enum Tiles {
    Empty = -1,
    LongGrass1,
    LongGrass2,
    LongGrass3,
}

#[methods]
impl TerrainObjects {
    pub fn new(_owner: &TileMap) -> Self {
        TerrainObjects
    }

    #[export]
    pub fn generate(&self, owner: &TileMap, noise: Ref<OpenSimplexNoise>, position: Vector2, size: Vector2) {
        self.generate_area(owner, noise, position, size)
    }
}

impl Terrain for TerrainObjects {
    fn get_tile_index(&self, sample: f64) -> i64 {
        (match sample {
            x if x < -0.8 => Tiles::LongGrass1,
            x if x < -0.6 => Tiles::LongGrass2,
            x if x < -0.4 => Tiles::LongGrass3,
            _ => Tiles::Empty
        }) as i64
    }
}
