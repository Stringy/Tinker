tool
extends Sprite

export (int) var regions = 100

func _ready():
    var size = get_viewport_rect().size
    var image = make_image()

    self.position = size / 2

    var texture = ImageTexture.new()
    texture.create_from_image(image)

    self.texture = texture

func _process(_delta):
    if Input.is_action_just_pressed("ui_select"):
        var image = make_image()
        var texture = ImageTexture.new()
        texture.create_from_image(image)
        self.texture = texture
        
func make_image() -> Image:
    var voronoi = Voronoi.new()

    var image = Image.new()
    var size = get_viewport_rect().size
    image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

    voronoi.draw_image(self.regions, image)

    return image


class Point:
    var type
    var position
    var citizens

class Voronoi:
    func draw_image(count: int, image: Image):
        var points = []
        var colours = []
        for i in count:
            points.push_back(
                Vector2(rand_range(0, image.get_size().x), rand_range(0, image.get_size().y))
            )
            colours.push_back(Color(randf(), randf(), randf(), 1.0))

        image.lock()
        for y in image.get_size().y:
            for x in image.get_size().x:
                var dmin = image.get_size().length()
                var colour_idx = -1
                for i in len(points):
                    var dist = (points[i] - Vector2(x, y)).length()
                    if dist < dmin:
                        dmin = dist
                        colour_idx = i

                image.set_pixel(x, y, colours[colour_idx])
