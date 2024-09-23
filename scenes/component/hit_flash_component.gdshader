shader_type canvas_item;

// a uniform is a variable we can set from outside the shader.
// hint_range clamps the value between two numbers IN THE EDITOR (could still exceed in code)
uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() { // Called for every pixel the material is visible on.
	// set the type (vec4) before declaring the variable
	// texture_color is getting the current colour of the pixel.
	vec4 texture_color = texture(TEXTURE, UV); // TEXTURE is a const that stores the texture. UV is a const that gets the coordinates of the current pixel
	// mix is like lerp(). We move from the texture_color to white (taking the pixel's own alpha color so that the transparent background doesn't go white.
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);

	COLOR = final_color;
}
