shader_type canvas_item;

uniform float shift_amount : hint_range(0.0, 1.0) = 0.0;

vec3 twilight_gradient(vec2 uv) {
    // Beautiful twilight colors (deep purple to warm orange)
    vec3 top_color = vec3(0.08, 0.05, 0.15);       // Very dark purple
    vec3 middle_color = vec3(0.3, 0.15, 0.4);      // Rich purple
    vec3 bottom_color = vec3(0.8, 0.3, 0.15);      // Warm orange
    
    float gradient = uv.y;
    vec3 color;
    
    if (gradient < 0.5) {
        color = mix(bottom_color, middle_color, gradient * 2.0);
    } else {
        color = mix(middle_color, top_color, (gradient - 0.5) * 2.0);
    }
    
    return color;
}

vec3 night_gradient(vec2 uv) {
    // Deep night colors (darker purples and blues)
    vec3 top_color = vec3(0.02, 0.02, 0.08);       // Almost black
    vec3 middle_color = vec3(0.1, 0.05, 0.2);      // Dark purple
    vec3 bottom_color = vec3(0.2, 0.1, 0.3);       // Slightly lighter purple
    
    float gradient = uv.y;
    vec3 color;
    
    if (gradient < 0.5) {
        color = mix(bottom_color, middle_color, gradient * 2.0);
    } else {
        color = mix(middle_color, top_color, (gradient - 0.5) * 2.0);
    }
    
    return color;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    vec3 twilight = twilight_gradient(uv);
    vec3 night = night_gradient(uv);
    
    vec3 final_color = mix(twilight, night, shift_amount);
    
    COLOR = vec4(final_color, 1.0);
}