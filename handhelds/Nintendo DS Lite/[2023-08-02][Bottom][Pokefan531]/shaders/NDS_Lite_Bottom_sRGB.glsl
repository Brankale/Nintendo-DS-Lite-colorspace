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
     1.01054329,  0.00420323, -0.01636087,
     0.00460884,  1.00189878, -0.00529682,
    -0.00338694,  0.00577018,  0.91304804
);

const int GAMMA_SAMPLES = 32;

float gamma_r[GAMMA_SAMPLES];
float gamma_g[GAMMA_SAMPLES];
float gamma_b[GAMMA_SAMPLES];

// 3DS gamma curve
void init_gamma_curve() {

    // gamma values between 10% and 90% are linearly interpolated.
    
    gamma_r[1] = 1.741;
    gamma_r[2] = 1.978;
    gamma_r[3] = 2.084;
    gamma_r[4] = 2.138;
    gamma_r[5] = 2.168;
    gamma_r[6] = 2.185;
    gamma_r[7] = 2.193;
    gamma_r[8] = 2.248;
    gamma_r[9] = 2.268;
    gamma_r[10] = 2.281;
    gamma_r[11] = 2.296;
    gamma_r[12] = 2.317;
    gamma_r[13] = 2.335;
    gamma_r[14] = 2.346;
    gamma_r[15] = 2.372;
    gamma_r[16] = 2.388;
    gamma_r[17] = 2.405;
    gamma_r[18] = 2.416;
    gamma_r[19] = 2.440;
    gamma_r[20] = 2.467;
    gamma_r[21] = 2.497;
    gamma_r[22] = 2.524;
    gamma_r[23] = 2.553;
    gamma_r[24] = 2.662;
    gamma_r[25] = 2.715;
    gamma_r[26] = 2.753;
    gamma_r[27] = 2.836;
    gamma_r[28] = 2.922;
    gamma_r[29] = 3.080;
    gamma_r[30] = 3.272;


    gamma_g[1] = 1.739;
    gamma_g[2] = 1.955;
    gamma_g[3] = 2.043;
    gamma_g[4] = 2.083;
    gamma_g[5] = 2.101;
    gamma_g[6] = 2.107;
    gamma_g[7] = 2.101;
    gamma_g[8] = 2.148;
    gamma_g[9] = 2.157;
    gamma_g[10] = 2.158;
    gamma_g[11] = 2.161;
    gamma_g[12] = 2.172;
    gamma_g[13] = 2.177;
    gamma_g[14] = 2.172;
    gamma_g[15] = 2.185;
    gamma_g[16] = 2.184;
    gamma_g[17] = 2.187;
    gamma_g[18] = 2.180;
    gamma_g[19] = 2.184;
    gamma_g[20] = 2.181;
    gamma_g[21] = 2.189;
    gamma_g[22] = 2.191;
    gamma_g[23] = 2.195;
    gamma_g[24] = 2.260;
    gamma_g[25] = 2.264;
    gamma_g[26] = 2.247;
    gamma_g[27] = 2.280;
    gamma_g[28] = 2.286;
    gamma_g[29] = 2.346;
    gamma_g[30] = 2.351;


    gamma_b[1] = 1.659;
    gamma_b[2] = 1.840;
    gamma_b[3] = 1.893;
    gamma_b[4] = 1.903;
    gamma_b[5] = 1.891;
    gamma_b[6] = 1.868;
    gamma_b[7] = 1.831;
    gamma_b[8] = 1.848;
    gamma_b[9] = 1.830;
    gamma_b[10] = 1.794;
    gamma_b[11] = 1.767;
    gamma_b[12] = 1.757;
    gamma_b[13] = 1.729;
    gamma_b[14] = 1.692;
    gamma_b[15] = 1.669;
    gamma_b[16] = 1.627;
    gamma_b[17] = 1.594;
    gamma_b[18] = 1.538;
    gamma_b[19] = 1.496;
    gamma_b[20] = 1.437;
    gamma_b[21] = 1.401;
    gamma_b[22] = 1.342;
    gamma_b[23] = 1.281;
    gamma_b[24] = 1.246;
    gamma_b[25] = 1.159;
    gamma_b[26] = 1.043;
    gamma_b[27] = 0.956;
    gamma_b[28] = 0.846;
    gamma_b[29] = 0.694;
    gamma_b[30] = 0.507;

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
    0.38154552,   0.35864595,   0.21545496,
    0.21216461,   0.65123694,   0.13659845,
    0.03269853,   0.07298532,   1.08431300
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