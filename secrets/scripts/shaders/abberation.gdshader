shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float strength = 0.05;
uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

// Controls how strongly the effect applies toward the edges
uniform float edge_falloff = 3.0; // Higher values make the effect stronger at edges

void fragment() {
	vec2 uv = FRAGCOORD.xy * SCREEN_PIXEL_SIZE;

	// Calculate the distance from the center of the screen
	vec2 screen_center = vec2(0.5, 0.5);
	float dist_from_center = distance(uv, screen_center);

	// Increase strength based on distance from center
	float edge_strength = strength * pow(dist_from_center, edge_falloff);

	vec4 colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec3 c = colour.rgb;

	// Adjust brightness, contrast, and saturation
	c = mix(vec3(0.0), c, brightness);
	c = mix(vec3(0.5), c, contrast);
	float luminance = dot(c, vec3(0.33333));
	c = mix(vec3(luminance), c, saturation);

	colour.rgb = c;

	// Apply color shift with edge-based strength
	colour.r = texture(screen_texture, uv + vec2(edge_strength / 3.0, 0.0)).r;
	colour.b = texture(screen_texture, uv + vec2(-2.0 * edge_strength / 3.0, 0.0)).b;

	COLOR = colour;
}
