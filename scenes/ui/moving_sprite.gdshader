shader_type canvas_item;

uniform float speed_multiplier : hint_range(0.1, 10.0) = 0.005;
uniform float bounce_range : hint_range(5.0, 50.0) = 15.0;
uniform float scale_range : hint_range(0.1, 2.0) = 0.4;
uniform float min_scale : hint_range(0.3, 1.0) = 0.6;
uniform float random_seed : hint_range(0.0, 1000.0) = 1.0;

// Simple pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Smooth noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void vertex() {
    // Extremely slow time progression for scary effect
    float glacial_time = TIME * speed_multiplier;

    // Create different frequencies for different movements using random seed
    vec2 seed_offset = vec2(random_seed, random_seed * 1.23);
    float scale_seed = random_seed * 2.34;

    // Generate extremely slow random movement using noise
    float offset_x = (noise(vec2(glacial_time * 0.3 + seed_offset.x, 0.0)) - 0.5) * bounce_range;
    float offset_y = (noise(vec2(glacial_time * 0.2 + seed_offset.y, 100.0)) - 0.5) * bounce_range;

    // Add some very slow circular/orbital motion
    float orbit_x = sin(glacial_time * 0.15 + random_seed) * bounce_range * 0.4;
    float orbit_y = cos(glacial_time * 0.1 + random_seed * 1.5) * bounce_range * 0.4;

    // Combine movements
    VERTEX.x += offset_x + orbit_x;
    VERTEX.y += offset_y + orbit_y;

    // Extremely slow scale changes - breathing/pulsing effect
    float scale_noise = noise(vec2(glacial_time * 0.08 + scale_seed, 50.0));
    float scale_pulse = sin(glacial_time * 0.12 + scale_seed) * 0.5 + 0.5;

    // Combine noise and pulse for organic scaling
    float scale_factor = min_scale + (scale_noise * 0.7 + scale_pulse * 0.3) * scale_range;

    // Apply non-uniform scaling for more unsettling effect
    float x_scale = scale_factor + sin(glacial_time * 0.09 + scale_seed) * 0.1;
    float y_scale = scale_factor + cos(glacial_time * 0.07 + scale_seed * 1.3) * 0.1;

    VERTEX.x *= x_scale;
    VERTEX.y *= y_scale;
}

void fragment() {
    COLOR = texture(TEXTURE, UV);
}