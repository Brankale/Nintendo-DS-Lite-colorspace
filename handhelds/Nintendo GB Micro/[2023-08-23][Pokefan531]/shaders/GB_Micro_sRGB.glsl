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
     1.02868356,  0.01175794, -0.03477476,
     0.01414741,  1.00160754, -0.01148983,
    -0.00687651,  0.01152085,  0.82231387
);

const int GAMMA_SAMPLES = 32;

float gamma_r[GAMMA_SAMPLES];
float gamma_g[GAMMA_SAMPLES];
float gamma_b[GAMMA_SAMPLES];

// 3DS gamma curve
void init_gamma_curve() {

    // gamma values between 10% and 90% are linearly interpolated.
    gamma_r[1] = 1.244;
    gamma_r[2] = 1.464;
    gamma_r[3] = 1.595;
    gamma_r[4] = 1.685;
    gamma_r[5] = 1.749;
    gamma_r[6] = 1.794;
    gamma_r[7] = 1.822;
    gamma_r[8] = 1.873;
    gamma_r[9] = 1.885;
    gamma_r[10] = 1.894;
    gamma_r[11] = 1.900;
    gamma_r[12] = 1.931;
    gamma_r[13] = 1.939;
    gamma_r[14] = 1.972;
    gamma_r[15] = 1.991;
    gamma_r[16] = 2.018;
    gamma_r[17] = 2.037;
    gamma_r[18] = 2.067;
    gamma_r[19] = 2.090;
    gamma_r[20] = 2.128;
    gamma_r[21] = 2.176;
    gamma_r[22] = 2.207;
    gamma_r[23] = 2.285;
    gamma_r[24] = 2.365;
    gamma_r[25] = 2.424;
    gamma_r[26] = 2.510;
    gamma_r[27] = 2.581;
    gamma_r[28] = 2.653;
    gamma_r[29] = 2.970;
    gamma_r[30] = 3.274;


    gamma_g[1] = 1.267;
    gamma_g[2] = 1.505;
    gamma_g[3] = 1.648;
    gamma_g[4] = 1.739;
    gamma_g[5] = 1.798;
    gamma_g[6] = 1.835;
    gamma_g[7] = 1.854;
    gamma_g[8] = 1.893;
    gamma_g[9] = 1.890;
    gamma_g[10] = 1.886;
    gamma_g[11] = 1.882;
    gamma_g[12] = 1.896;
    gamma_g[13] = 1.894;
    gamma_g[14] = 1.913;
    gamma_g[15] = 1.918;
    gamma_g[16] = 1.930;
    gamma_g[17] = 1.939;
    gamma_g[18] = 1.950;
    gamma_g[19] = 1.955;
    gamma_g[20] = 1.974;
    gamma_g[21] = 1.996;
    gamma_g[22] = 2.004;
    gamma_g[23] = 2.047;
    gamma_g[24] = 2.097;
    gamma_g[25] = 2.122;
    gamma_g[26] = 2.164;
    gamma_g[27] = 2.190;
    gamma_g[28] = 2.194;
    gamma_g[29] = 2.370;
    gamma_g[30] = 2.577;


    gamma_b[1] = 1.199;
    gamma_b[2] = 1.441;
    gamma_b[3] = 1.585;
    gamma_b[4] = 1.670;
    gamma_b[5] = 1.714;
    gamma_b[6] = 1.738;
    gamma_b[7] = 1.741;
    gamma_b[8] = 1.756;
    gamma_b[9] = 1.731;
    gamma_b[10] = 1.708;
    gamma_b[11] = 1.681;
    gamma_b[12] = 1.673;
    gamma_b[13] = 1.649;
    gamma_b[14] = 1.645;
    gamma_b[15] = 1.620;
    gamma_b[16] = 1.610;
    gamma_b[17] = 1.587;
    gamma_b[18] = 1.563;
    gamma_b[19] = 1.531;
    gamma_b[20] = 1.511;
    gamma_b[21] = 1.494;
    gamma_b[22] = 1.459;
    gamma_b[23] = 1.444;
    gamma_b[24] = 1.427;
    gamma_b[25] = 1.374;
    gamma_b[26] = 1.309;
    gamma_b[27] = 1.245;
    gamma_b[28] = 1.109;
    gamma_b[29] = 1.048;
    gamma_b[30] = 0.869;

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
    0.36505876,  0.38848100,  0.20355162,
    0.24011721,  0.56190793,  0.19797487,
    0.16989571,  0.22220691,  0.92627274
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
