use std::ptr::null;
use gdnative::prelude::*;
use gdnative::api::{ArrayMesh, SurfaceTool};

#[derive(NativeClass)]
#[inherit(Node)]
pub struct TerrainMesh {
    _inner: Mesh,
}

struct Mesh {
    _inner: Ref<ArrayMesh, Unique>,
}

impl Mesh {
    pub fn new(width: u32, height: u32) -> Self {
        let surface: TRef<SurfaceTool, Unique> = SurfaceTool::new().as_ref();

        for y in 0..height {
            for x in 0..width {
                surface.add_normal(Vector3::new(0.0, 0.0, 1.0));
                surface.add_uv(Vector2::new(x as f32, y as f32));
                surface.add_vertex(Vector3::new(x as f32, y as f32, 0.0));
            }
        }

        surface.index();

        Mesh {
            _inner: surface.commit(null(), 97280).unwrap()
        }
    }
}

#[methods]
impl TerrainMesh {
    pub fn new(_owner: &Node) -> Self {
        Self {
            _inner: Mesh::new(30, 30)
        }
    }

    #[export]
    pub fn _ready(&self, _owner: &Node) {
        godot_print!("terrain mesh ready!");
    }
}