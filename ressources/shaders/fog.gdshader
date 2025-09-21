shader_type canvas_item;

// Uniforms for customization
uniform sampler2D noise_texture : repeat_enable;
uniform vec4 smoke_color : source_color = vec4(0.8);
uniform float distortion_speed : hint_range(0.0, 5.0) = 0.2;
uniform float density : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    float t = TIME * distortion_speed;

	// Slow, gentle, quasi-random offsets
	float time_offset_1 = 0.05 * sin(t * 0.5 + 1.0)
	                    + 0.03 * cos(t * 0.7 + 2.0)
	                    + 0.02 * sin(t * 1.1 + 0.3);

	float time_offset_2 = 0.04 * cos(t * 0.6 + 1.5)
	                    + 0.03 * sin(t * 0.9 + 0.8)
	                    + 0.02 * cos(t * 1.3 + 0.2);

    // Sample noise with distortion
    vec4 noise = texture(noise_texture, UV + time_offset_1);

    // Create distorted UV and sample final noise
    vec2 distorted_uv = UV + noise.rg * 0.1 - 0.05 + time_offset_2;
    float final_noise = texture(noise_texture, distorted_uv).r;

    float smoke_alpha = final_noise * density * smoke_color.a;

    // Output color
    COLOR = vec4(smoke_color.rgb, smoke_alpha);
}