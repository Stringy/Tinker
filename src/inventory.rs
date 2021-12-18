use gdnative::prelude::*;
use gdnative::api::Resource;
use gdnative::export::Export;

#[derive(NativeClass)]
#[inherit(Resource)]
pub struct Inventory;

#[methods]
impl Inventory {
    pub fn new(_owner: &Resource) -> Self {
        Inventory
    }

    #[export]
    pub fn _ready(&self, owner: &Resource) {

    }
}