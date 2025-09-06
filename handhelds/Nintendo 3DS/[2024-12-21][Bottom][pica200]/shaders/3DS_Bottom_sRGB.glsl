/*

    Author: Brankale

    Special thanks:
    - "pica200" who provided the measurements.

*/

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

// 3DS -> sRGB chromatic adaptation
const mat3 chromatic_adaptation_bradford_mtx = mat3(
     1.03850679,  0.01021215, -0.06254955,
     0.00859495,  1.02350713, -0.01977019,
    -0.01361733,  0.02360227,  0.66399804
);

float gamma_r[11];
float gamma_g[11];
float gamma_b[11];

// 3DS gamma curve
void init_gamma_curve() {

    // gamma values between 10% and 90% are linearly interpolated.
    
    gamma_r[1] = 1.950;
    gamma_r[2] = 2.060;
    gamma_r[3] = 2.108;
    gamma_r[4] = 2.171;
    gamma_r[5] = 2.199;
    gamma_r[6] = 2.221;
    gamma_r[7] = 2.321;
    gamma_r[8] = 2.382;
    gamma_r[9] = 2.596;

    gamma_g[1] = 1.820;
    gamma_g[2] = 1.858;
    gamma_g[3] = 1.866;
    gamma_g[4] = 1.890;
    gamma_g[5] = 1.886;
    gamma_g[6] = 1.869;
    gamma_g[7] = 1.878;
    gamma_g[8] = 1.872;
    gamma_g[9] = 1.901;

    gamma_b[1] = 1.729;
    gamma_b[2] = 1.715;
    gamma_b[3] = 1.638;
    gamma_b[4] = 1.566;
    gamma_b[5] = 1.434;
    gamma_b[6] = 1.281;
    gamma_b[7] = 1.106;
    gamma_b[8] = 0.822;
    gamma_b[9] = 0.395;

    // Near black gamma & Near white gamma are approximated with 4% and 96% gamma values.

    gamma_r[0] = 1.802;
    gamma_r[10] = 2.496;
	
    gamma_g[0] = 1.764;
    gamma_g[10] = 1.826;

    gamma_b[0] = 1.523;
    gamma_b[10] = -0.052;
}

// 3DS: RGB -> XYZ
const mat3 src_rgb2xyz_mtx = mat3(
    0.38020543,  0.34372046,  0.27933971,
    0.22404846,  0.64353231,  0.13241923,
    0.05297244,  0.07590981,  1.49629917
);


float lerp(float intensity, float gamma[11]) {
    float floor = floor(intensity * 10.0);
    float ceil = ceil(intensity * 10.0);
    float weight = 1.0 - (ceil - (intensity * 10.0));
    return mix(gamma[int(floor)], gamma[int(ceil)], weight);
}

// 3DS EOTF
vec3 src_eotf(vec3 color) {
    float gr = lerp(color.x, gamma_r);
    float gg = lerp(color.y, gamma_g);
    float gb = lerp(color.z, gamma_b);

    color.x = pow(color.x, gr);
    color.y = pow(color.y, gg);
    color.z = pow(color.z, gb);
    
    return color;
}

// sRGB OETF
float dst_oetf(float color) {
    if (color <= 0.0031308)
        return 12.92 * color;
    else
        return (1.055 * pow(color, 1.0 / 2.4)) - 0.055;
}

// sRGB OETF
vec3 dst_oetf(vec3 color) {
    color.x = dst_oetf(color.x);
    color.y = dst_oetf(color.y);
    color.z = dst_oetf(color.z);
    return color;
}

// sRGB: XYZ -> RGB
const mat3 dst_xyz2rgb_mtx = mat3(
     3.2406255, -1.5372080, -0.4986286,
    -0.9689307,  1.8757561,  0.0415175,
     0.0557101, -0.2040211,  1.0569959
);

// Pre/Post Processing

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

void main() {

    init_gamma_curve();

    vec4 src_color = texture2D(Texture, tex_coord);

    // pre processing
    // 3DS has 8bits per channel ==> skip quantization step

    // 1. EOTF
    vec3 src_linearized_rgb = src_eotf(src_color.xyz);

    // 2. source linearized RGB -> source XYZ
    vec3 src_xyz = src_rgb2xyz_mtx * src_linearized_rgb;

    // 3. chromatic adaptation
    vec3 dst_xyz = chromatic_adaptation_bradford_mtx * src_xyz;

    // 4. destination XYZ -> destination linearized RGB
    vec3 dst_linearized_rgb = dst_xyz2rgb_mtx * dst_xyz;

    // 5. OETF
    vec3 dst_rgb = dst_oetf(dst_linearized_rgb);

    // post processing: out of gamut
    //dst_rgb = compute_out_of_gamut(dst_rgb, dst_xyz.y);

    gl_FragColor = vec4(dst_rgb.xyz, src_color.w);
}

#endif