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
    9.98328875e-01, -9.13269638e-04, -2.20039687e-02,
    2.48554652e-05,  9.98260496e-01,  1.31901219e-03,
    3.36395329e-04, -7.94928070e-03,  8.43405923e-01
);

const int GAMMA_SAMPLES = 32;

float gamma_r[GAMMA_SAMPLES];
float gamma_g[GAMMA_SAMPLES];
float gamma_b[GAMMA_SAMPLES];

// 3DS gamma curve
void init_gamma_curve() {

    // gamma values between 10% and 90% are linearly interpolated.
    
    gamma_r[1] = 1.330;
    gamma_r[2] = 1.569;
    gamma_r[3] = 1.722;
    gamma_r[4] = 1.821;
    gamma_r[5] = 1.893;
    gamma_r[6] = 1.935;
    gamma_r[7] = 1.967;
    gamma_r[8] = 2.009;
    gamma_r[9] = 2.023;
    gamma_r[10] = 2.033;
    gamma_r[11] = 2.048;
    gamma_r[12] = 2.065;
    gamma_r[13] = 2.084;
    gamma_r[14] = 2.107;
    gamma_r[15] = 2.141;
    gamma_r[16] = 2.173;
    gamma_r[17] = 2.198;
    gamma_r[18] = 2.227;
    gamma_r[19] = 2.255;
    gamma_r[20] = 2.290;
    gamma_r[21] = 2.329;
    gamma_r[22] = 2.362;
    gamma_r[23] = 2.413;
    gamma_r[24] = 2.529;
    gamma_r[25] = 2.583;
    gamma_r[26] = 2.677;
    gamma_r[27] = 2.752;
    gamma_r[28] = 2.901;
    gamma_r[29] = 3.023;
    gamma_r[30] = 3.512;


    gamma_g[1] = 1.327;
    gamma_g[2] = 1.592;
    gamma_g[3] = 1.759;
    gamma_g[4] = 1.861;
    gamma_g[5] = 1.930;
    gamma_g[6] = 1.969;
    gamma_g[7] = 1.991;
    gamma_g[8] = 2.018;
    gamma_g[9] = 2.020;
    gamma_g[10] = 2.017;
    gamma_g[11] = 2.017;
    gamma_g[12] = 2.021;
    gamma_g[13] = 2.031;
    gamma_g[14] = 2.041;
    gamma_g[15] = 2.056;
    gamma_g[16] = 2.072;
    gamma_g[17] = 2.083;
    gamma_g[18] = 2.096;
    gamma_g[19] = 2.106;
    gamma_g[20] = 2.115;
    gamma_g[21] = 2.137;
    gamma_g[22] = 2.151;
    gamma_g[23] = 2.167;
    gamma_g[24] = 2.251;
    gamma_g[25] = 2.272;
    gamma_g[26] = 2.302;
    gamma_g[27] = 2.351;
    gamma_g[28] = 2.393;
    gamma_g[29] = 2.453;
    gamma_g[30] = 2.736;


    gamma_b[1] = 1.244;
    gamma_b[2] = 1.510;
    gamma_b[3] = 1.682;
    gamma_b[4] = 1.779;
    gamma_b[5] = 1.839;
    gamma_b[6] = 1.859;
    gamma_b[7] = 1.861;
    gamma_b[8] = 1.865;
    gamma_b[9] = 1.845;
    gamma_b[10] = 1.817;
    gamma_b[11] = 1.794;
    gamma_b[12] = 1.773;
    gamma_b[13] = 1.755;
    gamma_b[14] = 1.739;
    gamma_b[15] = 1.725;
    gamma_b[16] = 1.709;
    gamma_b[17] = 1.687;
    gamma_b[18] = 1.662;
    gamma_b[19] = 1.633;
    gamma_b[20] = 1.603;
    gamma_b[21] = 1.575;
    gamma_b[22] = 1.542;
    gamma_b[23] = 1.493;
    gamma_b[24] = 1.488;
    gamma_b[25] = 1.421;
    gamma_b[26] = 1.345;
    gamma_b[27] = 1.273;
    gamma_b[28] = 1.145;
    gamma_b[29] = 0.968;
    gamma_b[30] = 0.765;

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
    0.39543220,   0.37532072,   0.21086835,
    0.25291318,   0.52177008,   0.22531674,
    0.15277334,   0.28205063,   0.86547140
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