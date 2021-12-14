shader_type canvas_item;

uniform vec4 flash_colour: hint_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 1;

void fragment() {
    vec4 colour = texture(TEXTURE, UV);
    colour.rgb = mix(colour.rgb, flash_colour.rgb, flash_modifier);
    COLOR = colour;
}
