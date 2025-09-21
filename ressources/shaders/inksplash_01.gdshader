shader_type canvas_item;

/*
Ink Splash shader for Polygon2D (Godot 4.4)
- Put this shader in a ShaderMaterial assigned to the Polygon2D.
- The shader reads vertex positions as local coordinates (so splash_center is in polygon local space).
*/

uniform vec4 ink_color : source_color  = vec4(0.06, 0.06, 0.06, 1.0);
uniform sampler2D ink_texture : source_color, filter_linear, repeat_disable;
uniform vec2 splash_center = vec2(0.0, 0.0);
uniform float radius : hint_range(0.0, 2048.0) = 100.0;
uniform float edge_softness : hint_range(0.0, 200.0) = 12.0;
uniform float jitter : hint_range(0.0, 200.0) = 12.0; // how "blobby" the edge is
uniform float bleed : hint_range(0.0, 1.0) = 0.45; // inner bleed darkness
uniform float time : hint_range(0.0, 1000.0) = 0.0; // for animated noise
uniform int splat_count : hint_range(0,8) = 3; // extra satellite splats
uniform float splat_strength : hint_range(0.0,2.0) = 0.6; // how strong satellites are
uniform bool use_polygon_texture = true; // if true, mixes with polygon texture (if set)
uniform float seed : hint_range(0.0, 1000.0) = 0.0;

// VARYING to pass local position from vertex() to fragment()
varying vec2 v_local_pos;
varying vec2 v_uv;

float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21) + seed);
    p += dot(p, p + 78.233);
    return fract(p.x * p.y);
}
float noise(vec2 p) {
    // simple value noise (2D)
    vec2 i = floor(p);
    vec2 f = fract(p);
    // four corners
    float a = hash21(i + vec2(0.0,0.0));
    float b = hash21(i + vec2(1.0,0.0));
    float c = hash21(i + vec2(0.0,1.0));
    float d = hash21(i + vec2(1.0,1.0));
    // smoothstep fade
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    mat2 m = mat2(vec2(1.6, -1.2), vec2( 1.2,  1.6));
    for (int i = 0; i < 4; ++i) {
        v += a * noise(p);
        p = m * p * 1.9 + time * 0.05;
        a *= 0.5;
    }
    return v;
}

void vertex() {
    // VERTEX is in local polygon coordinate space
    v_local_pos = VERTEX;
    // UV (if polygon has texcoords) -> fallback to normalized local bounding rect via VERTEX if UV not set
    v_uv = UV;
}

void fragment() {
    vec2 P = v_local_pos;

    // base distance to main splash center
    float d = length(P - splash_center);

    // large-scale noise to distort radius (makes the edge blobby)
    float n = fbm((P - splash_center) * 0.02 + seed);

    // main mask: we offset the effective distance by noise*jitter so the edge is organic
    float effective_d = d + (n - 0.5) * jitter;

    // soft step to make an anti-aliased edge
    float main_mask = 1.0 - smoothstep(radius - edge_softness, radius + edge_softness, effective_d);

    // inner bleed: darken near center a bit (so center looks saturated)
    float inner = smoothstep(0.0, radius * 0.6, d);
    float bleed_mask = mix(1.0, inner, bleed);

    // satellite splats (randomly placed around main center)
    float satellites = 0.0;
    for (int i = 0; i < 8; ++i) { // compile-time loop, but we only use splat_count
        if (i >= splat_count) break;
        float ang = hash21(vec2(float(i)*12.989, seed + float(i))) * 6.2831853;
        float rad = radius * (0.3 + 0.6 * hash21(vec2(float(i)*7.1, seed + 30.0)));
        vec2 sc = splash_center + vec2(cos(ang), sin(ang)) * rad * (0.6 + 0.8 * hash21(vec2(float(i)*3.3, seed + 55.0)));
        float sd = length(P - sc);
        float s_n = fbm((P - sc) * 0.04 + seed + float(i)*0.7);
        float s_eff = sd + (s_n - 0.5) * (jitter * 0.7);
        float s_mask = 1.0 - smoothstep(radius*0.12, radius*0.35, s_eff) ; // small splat
        satellites += s_mask * (splat_strength * (0.6 + 0.6 * hash21(vec2(float(i)*9.2, seed+10.0))));
    }

    // combine main + satellites
    float combined = clamp(main_mask + satellites, 0.0, 1.0);

    // add very fine edge texture (tiny droplets / speckles)
    float speck = smoothstep(0.98, 1.0, fbm(P * 0.6 + seed * 3.14) * 1.5);
    combined = clamp(combined + speck * 0.08, 0.0, 1.0);

    // apply inner bleed darkness
    combined *= bleed_mask;

    // final alpha falloff (so edges fade to transparent)
    float alpha = combined;

    // output color: choose either fill color or mix with polygon texture
    vec4 base = texture(ink_texture, v_uv);
    // If user wants the polygon texture preserved where there's no ink, we'll mix.
    // `use_polygon_texture` toggles this behavior.
    vec4 out_col;
    if (use_polygon_texture) {
        // blend ink over the polygon's texture (standard over operator)
        vec4 ink = vec4(ink_color.rgb, ink_color.a * alpha);
        // premultiplied mix:
        out_col = mix(COLOR, ink, ink.a);
        // keep polygon texture when no ink:
        out_col.a = max(base.a, ink.a);
    } else {
        out_col = vec4(ink_color.rgb, ink_color.a * alpha);
    }

    COLOR = out_col;
}
