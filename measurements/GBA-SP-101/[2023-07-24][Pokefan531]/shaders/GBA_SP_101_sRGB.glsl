/*

    Author: Brankale

    Special thanks:
    - "Pokefan531" who provided the measurements.

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
     0.99439258, -0.00593036, -0.01908362,
    -0.01131626,  1.01769167, -0.0052902,
    -0.00518725,  0.00958276,  0.87739332
);

const int GAMMA_SAMPLES = 32;

float gamma_r[GAMMA_SAMPLES];
float gamma_g[GAMMA_SAMPLES];
float gamma_b[GAMMA_SAMPLES];

// 3DS gamma curve
void init_gamma_curve() {

    // gamma values between 10% and 90% are linearly interpolated.
    gamma_r[1] = 1.555;
    gamma_r[2] = 1.867;
    gamma_r[3] = 2.095;
    gamma_r[4] = 2.238;
    gamma_r[5] = 2.293;
    gamma_r[6] = 2.282;
    gamma_r[7] = 2.251;
    gamma_r[8] = 2.237;
    gamma_r[9] = 2.259;
    gamma_r[10] = 2.272;
    gamma_r[11] = 2.249;
    gamma_r[12] = 2.266;
    gamma_r[13] = 2.337;
    gamma_r[14] = 2.367;
    gamma_r[15] = 2.423;
    gamma_r[16] = 2.484;
    gamma_r[17] = 2.515;
    gamma_r[18] = 2.603;
    gamma_r[19] = 2.690;
    gamma_r[20] = 2.751;
    gamma_r[21] = 2.766;
    gamma_r[22] = 2.833;
    gamma_r[23] = 2.804;
    gamma_r[24] = 2.919;
    gamma_r[25] = 2.889;
    gamma_r[26] = 3.038;
    gamma_r[27] = 3.079;
    gamma_r[28] = 2.937;
    gamma_r[29] = 2.549;
    gamma_r[30] = 2.029;


    gamma_g[1] = 1.575;
    gamma_g[2] = 1.880;
    gamma_g[3] = 2.101;
    gamma_g[4] = 2.227;
    gamma_g[5] = 2.269;
    gamma_g[6] = 2.242;
    gamma_g[7] = 2.195;
    gamma_g[8] = 2.168;
    gamma_g[9] = 2.182;
    gamma_g[10] = 2.186;
    gamma_g[11] = 2.152;
    gamma_g[12] = 2.163;
    gamma_g[13] = 2.221;
    gamma_g[14] = 2.241;
    gamma_g[15] = 2.286;
    gamma_g[16] = 2.332;
    gamma_g[17] = 2.355;
    gamma_g[18] = 2.427;
    gamma_g[19] = 2.497;
    gamma_g[20] = 2.549;
    gamma_g[21] = 2.544;
    gamma_g[22] = 2.586;
    gamma_g[23] = 2.527;
    gamma_g[24] = 2.609;
    gamma_g[25] = 2.552;
    gamma_g[26] = 2.678;
    gamma_g[27] = 2.670;
    gamma_g[28] = 2.530;
    gamma_g[29] = 2.164;
    gamma_g[30] = 1.605;


    gamma_b[1] = 1.465;
    gamma_b[2] = 1.744;
    gamma_b[3] = 1.941;
    gamma_b[4] = 2.046;
    gamma_b[5] = 2.066;
    gamma_b[6] = 2.018;
    gamma_b[7] = 1.951;
    gamma_b[8] = 1.900;
    gamma_b[9] = 1.891;
    gamma_b[10] = 1.871;
    gamma_b[11] = 1.820;
    gamma_b[12] = 1.803;
    gamma_b[13] = 1.836;
    gamma_b[14] = 1.827;
    gamma_b[15] = 1.838;
    gamma_b[16] = 1.853;
    gamma_b[17] = 1.837;
    gamma_b[18] = 1.870;
    gamma_b[19] = 1.903;
    gamma_b[20] = 1.906;
    gamma_b[21] = 1.847;
    gamma_b[22] = 1.841;
    gamma_b[23] = 1.712;
    gamma_b[24] = 1.711;
    gamma_b[25] = 1.581;
    gamma_b[26] = 1.638;
    gamma_b[27] = 1.523;
    gamma_b[28] = 1.338;
    gamma_b[29] = 1.072;
    gamma_b[30] = 0.848;

    // Near black gamma & Near white gamma are approximated with 4% and 96% gamma values.

    gamma_r[0] = gamma_r[1];
    gamma_r[31] = gamma_r[30];
	
    gamma_g[0] = gamma_g[1];
    gamma_g[31] = gamma_g[30];

    gamma_b[0] = gamma_b[1];
    gamma_b[31] = gamma_b[30];
}

// 3DS: RGB -> XYZ
const mat3 src_rgb2xyz_mtx = mat3(
    0.42414737,   0.34738533,   0.21396987,
    0.23823392,   0.63557872,   0.12618736,
    0.02695297,   0.06653846,   1.14265548
);


float lerp(float intensity, float gamma[GAMMA_SAMPLES]) {
    float tmp = intensity * float(GAMMA_SAMPLES - 1);
    float floor = floor(tmp);
    float ceil = ceil(tmp);
    float weight = 1.0 - (ceil - tmp);
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
    // TODO: quantization step

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

    gl_FragColor = vec4(dst_rgb, src_color.w);
}

#endif