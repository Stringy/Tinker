use gdnative::prelude::*;
use gdnative::api::TileMap;
use gdnative::api::OpenSimplexNoise;
use crate::terrain::ground::Ground;
use crate::terrain::objects::TerrainObjects;

pub mod objects;
pub mod ground;

pub trait Terrain {
    fn generate_area(&self, owner: &TileMap, noise: Ref<OpenSimplexNoise>, position: Vector2, size: Vector2) {
        let position = owner.world_to_map(position);

        let x_coord = position.x - (size.x / 2.0);
        let y_coord = position.y - (size.y / 2.0);

        let noise = unsafe { noise.assume_safe() };

        for y in 0..(size.y as i32) {
            for x in 0..(size.x as i32) {
                let real_x = (x_coord + x as f32) as f64;
                let real_y = (y_coord + y as f32) as f64;

                owner.set_cellv(
                    Vector2::new(real_x as f32, real_y as f32),
                    self.get_tile_index(noise.get_noise_2d(real_x, real_y)),
                    false,
                    false,
                    false
                )
            }
        }
    }

    fn get_tile_index(&self, sample: f64) -> i64;
}

pub fn init(handle: &InitHandle) {
    handle.add_class::<TerrainObjects>();
    handle.add_class::<Ground>();
}