
shader_type canvas_item;

uniform float shift_amount : hint_range(0.0, 1.0);

void fragment() {
    vec3 twilight = vec3(0.2, 0.1, 0.4);
    vec3 dusk = vec3(0.9, 0.6, 0.2);
    COLOR.rgb = mix(twilight, dusk, shift_amount);
    COLOR.a = 1.0;
}
