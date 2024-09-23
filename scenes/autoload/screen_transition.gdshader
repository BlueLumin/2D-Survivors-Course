shader_type canvas_item;

uniform vec4 transition_colour : source_color;
uniform sampler2D transition_texture : filter_nearest;
uniform float percent : hint_range(0.0, 1.0);


void fragment() {
	vec4 transition_texture_colour = texture(transition_texture, UV); // Getting the colour from the texture
	if (transition_texture_colour.r > percent) {
		COLOR.a = 0.0;
	}
	else {
		COLOR = transition_colour;
	}
}
