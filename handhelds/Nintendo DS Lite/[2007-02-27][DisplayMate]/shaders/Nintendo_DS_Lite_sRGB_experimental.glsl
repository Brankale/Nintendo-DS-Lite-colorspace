varying vec2 tex_coord;
#if defined(VERTEX)
attribute vec2 TexCoord;
attribute vec2 VertexCoord;
uniform mat4 MVPMatrix;
void main()
{
    gl_Position = MVPMatrix * vec4(VertexCoord, 0.0, 1.0);
    tex_coord = TexCoord;
}
#elif defined(FRAGMENT)
uniform sampler2D Texture;

// NDS Lite

const float NDS_LITE_SCREEN_DEPTH = 64.0;             // 6-bit depth screen 

vec3 eotf_ds(vec3 color) {
    // TODO: Greyscale gamma is not enough to get accurate colors.
    //       Find red, green and blue channels gamma.
    float GREYSCALE_GAMMA = 1.85;
    color.x = pow(color.x, GREYSCALE_GAMMA);
    color.y = pow(color.y, GREYSCALE_GAMMA);
    color.z = pow(color.z, GREYSCALE_GAMMA);
    return color;
}

const mat3 ndsl_rgb2xyz = mat3(
    0.42210, 0.34542, 0.20576,
    0.23889, 0.63475, 0.12637,
    0.03620, 0.06307, 1.08107
);

// sRGB

float oetf_srgb(float color) {
    if (color <= 0.0031308)
        return 12.92 * color;
    else
        return (1.055 * pow(color, 1.0 / 2.4)) - 0.055;
}

vec3 oetf_srgb(vec3 color) {
    color.x = oetf_srgb(color.x);
    color.y = oetf_srgb(color.y);
    color.z = oetf_srgb(color.z);
    return color;
}

const mat3 srgb_d65_rgb2xyz_inv = mat3(
     3.2406255, -1.5372080, -0.4986286,
    -0.9689307,  1.8757561,  0.0415175,
     0.0557101, -0.2040211,  1.0569959
);

// Chromatic Adaptation

const mat3 chromatic_adaptation_ciecat16 = mat3(
     1.0013,    -0.0078801, -0.013736,
    -0.0057558,  1.0119,    -0.0053580,
    -0.00032190, 0.0012693,  0.92185
);

// Pre-Processing + Post Processing 

vec3 quantize(vec3 color, float levels) {
    return floor(color * levels) / levels;
}

bool is_out_of_gamut(vec3 color) {
    return (color.x < 0.0 || color.x > 1.0) || (color.y < 0.0 || color.y > 1.0) || (color.z < 0.0 || color.z > 1.0);
}

vec3 compute_out_of_gamut(vec3 color, float luminance) {
    float grey = (color.x + color.y + color.z) / 3.0;

    if (is_out_of_gamut(color))
        return vec3(1.0, grey / 2.5, grey / 2.5);
    else
        return vec3(grey, grey, grey);
}

void main()
{
    vec4 source_color = texture2D(Texture, tex_coord);

    // pre-processing: quantization
    vec3 target_rgb = quantize(source_color.xyz, NDS_LITE_SCREEN_DEPTH - 1.0);

    // 1. EOTF
    vec3 target_linearized_rgb = eotf_ds(target_rgb);

    // 2. target linearized RGB -> target XYZ
    vec3 target_xyz = ndsl_rgb2xyz * target_linearized_rgb;

    // TODO: (optional) add min screen luminance effect

    // 3. chromatic adaptation
    vec3 display_xyz = chromatic_adaptation_ciecat16 * target_xyz;

    // 4. display XYZ -> display linearized RGB
    vec3 display_linearized_rgb = srgb_d65_rgb2xyz_inv * display_xyz;

    // 5. OETF
    vec3 display_rgb = oetf_srgb(display_linearized_rgb);

    // post processing: out of gamut
    // display_rgb = compute_out_of_gamut(display_rgb, display_xyz.y);

    gl_FragColor = vec4(display_rgb.x, display_rgb.y, display_rgb.z, source_color.w);

}

#endif
