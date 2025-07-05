shader_type spatial;

uniform sampler2D noise;
uniform sampler2D base_color;
uniform sampler2D normal;
uniform float pan_speed = 0.05;
uniform float strength = 0.25;

void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz * 0.05;
	vec2 animated_uv = fract(world_pos.xz + vec2(TIME * pan_speed));
	float noise_val = texture(noise, animated_uv).r;
	VERTEX.y = noise_val * strength;
}

void fragment() {
	ALBEDO = vec3(1.0, 0.0, 0.0);
	NORMAL = texture(normal, UV).rgb;
	ALPHA = 0.75;
}