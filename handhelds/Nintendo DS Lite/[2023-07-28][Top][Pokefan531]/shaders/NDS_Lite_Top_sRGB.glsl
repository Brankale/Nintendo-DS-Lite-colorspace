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
     0.99844768, -0.00464908, -0.02577924,
    -0.01010634,  1.01956142, -0.00742192,
    -0.00662344,  0.01205973,  0.84141607
);

const int GAMMA_SAMPLES = 32;

float gamma_r[GAMMA_SAMPLES];
float gamma_g[GAMMA_SAMPLES];
float gamma_b[GAMMA_SAMPLES];

// 3DS gamma curve
void init_gamma_curve() {

    // gamma values between 10% and 90% are linearly interpolated.
    
    gamma_r[1] = 1.760;
    gamma_r[2] = 1.976;
    gamma_r[3] = 2.066;
    gamma_r[4] = 2.111;
    gamma_r[5] = 2.134;
    gamma_r[6] = 2.142;
    gamma_r[7] = 2.157;
    gamma_r[8] = 2.196;
    gamma_r[9] = 2.211;
    gamma_r[10] = 2.224;
    gamma_r[11] = 2.232;
    gamma_r[12] = 2.245;
    gamma_r[13] = 2.258;
    gamma_r[14] = 2.264;
    gamma_r[15] = 2.294;
    gamma_r[16] = 2.306;
    gamma_r[17] = 2.319;
    gamma_r[18] = 2.329;
    gamma_r[19] = 2.349;
    gamma_r[20] = 2.385;
    gamma_r[21] = 2.395;
    gamma_r[22] = 2.412;
    gamma_r[23] = 2.455;
    gamma_r[24] = 2.528;
    gamma_r[25] = 2.569;
    gamma_r[26] = 2.603;
    gamma_r[27] = 2.673;
    gamma_r[28] = 2.774;
    gamma_r[29] = 2.894;
    gamma_r[30] = 3.042;


    gamma_g[1] = 1.742;
    gamma_g[2] = 1.942;
    gamma_g[3] = 2.020;
    gamma_g[4] = 2.055;
    gamma_g[5] = 2.071;
    gamma_g[6] = 2.072;
    gamma_g[7] = 2.079;
    gamma_g[8] = 2.110;
    gamma_g[9] = 2.115;
    gamma_g[10] = 2.119;
    gamma_g[11] = 2.120;
    gamma_g[12] = 2.124;
    gamma_g[13] = 2.126;
    gamma_g[14] = 2.120;
    gamma_g[15] = 2.138;
    gamma_g[16] = 2.136;
    gamma_g[17] = 2.137;
    gamma_g[18] = 2.129;
    gamma_g[19] = 2.132;
    gamma_g[20] = 2.150;
    gamma_g[21] = 2.138;
    gamma_g[22] = 2.134;
    gamma_g[23] = 2.162;
    gamma_g[24] = 2.184;
    gamma_g[25] = 2.184;
    gamma_g[26] = 2.189;
    gamma_g[27] = 2.209;
    gamma_g[28] = 2.260;
    gamma_g[29] = 2.277;
    gamma_g[30] = 2.245;


    gamma_b[1] = 1.635;
    gamma_b[2] = 1.801;
    gamma_b[3] = 1.847;
    gamma_b[4] = 1.853;
    gamma_b[5] = 1.840;
    gamma_b[6] = 1.811;
    gamma_b[7] = 1.790;
    gamma_b[8] = 1.793;
    gamma_b[9] = 1.768;
    gamma_b[10] = 1.746;
    gamma_b[11] = 1.710;
    gamma_b[12] = 1.685;
    gamma_b[13] = 1.651;
    gamma_b[14] = 1.612;
    gamma_b[15] = 1.599;
    gamma_b[16] = 1.553;
    gamma_b[17] = 1.514;
    gamma_b[18] = 1.464;
    gamma_b[19] = 1.416;
    gamma_b[20] = 1.381;
    gamma_b[21] = 1.310;
    gamma_b[22] = 1.251;
    gamma_b[23] = 1.230;
    gamma_b[24] = 1.132;
    gamma_b[25] = 1.042;
    gamma_b[26] = 0.981;
    gamma_b[27] = 0.867;
    gamma_b[28] = 0.828;
    gamma_b[29] = 0.642;
    gamma_b[30] = 0.323;

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
    0.39198174,   0.36366875,   0.23418890,
    0.21728507,   0.64924580,   0.13346914,
    0.03895833,   0.07169253,   1.17712364
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