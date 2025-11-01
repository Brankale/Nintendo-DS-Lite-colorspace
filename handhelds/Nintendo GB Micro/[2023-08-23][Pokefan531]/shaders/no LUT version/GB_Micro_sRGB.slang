#version 450

layout(set = 0, binding = 0, std140) uniform UBO
{
   mat4 MVP;
   //float BitDepth;
   float ChromaticAdaptation;
   float DebugOutOfGamut;
   float RedScale;
   float GreenScale;
   float BlueScale;
};

//#pragma parameter BitDepth "Screen bit depth" 5.0 1.0 12.0 1.0
#pragma parameter ChromaticAdaptation "Chromatic Adaptation (0 = OFF, 1 = ON)" 1.0 0.0 1.0 1.0
#pragma parameter DebugOutOfGamut "[Debug] Show `out of Gamut` colours" 0.0 0.0 1.0 1.0
#pragma parameter RedScale "[Debug] RED scale " 0.0 0.0 1.0 1.0
#pragma parameter GreenScale "[Debug] GREEN scale " 0.0 0.0 1.0 1.0
#pragma parameter BlueScale "[Debug] BLUE scale " 0.0 0.0 1.0 1.0

#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;

void main()
{
   gl_Position = MVP * Position;
   vTexCoord = TexCoord;
}

#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 FragColor;
layout(binding = 1) uniform sampler2D Source;


const int GAMMA_SAMPLES = 32;

const float GAMMA_RED[GAMMA_SAMPLES] = float[](
   1.985, // gamma[0] = gamma[1]
   1.985, 2.099, 2.078, 1.999, 2.052, 2.106, 2.136, 2.152, 2.167, 2.179,
   2.207, 2.220, 2.244, 2.259, 2.275, 2.293, 2.309, 2.319, 2.338, 2.369,
   2.390, 2.403, 2.440, 2.456, 2.514, 2.544, 2.596, 2.646, 2.701, 2.760, 
   2.760  // gamma[31] = gamma[30]
);

const float GAMMA_GREEN[GAMMA_SAMPLES] = float[](
   1.876, // gamma[0] = gamma[1]
   1.876, 1.970, 1.960, 1.898, 1.956, 2.016, 2.052, 2.075, 2.098, 2.113,
   2.146, 2.167, 2.196, 2.216, 2.237, 2.263, 2.282, 2.297, 2.321, 2.355,
   2.380, 2.399, 2.441, 2.458, 2.518, 2.552, 2.604, 2.651, 2.701, 2.742, 
   2.742  // gamma[31] = gamma[30]
);

const float GAMMA_BLUE[GAMMA_SAMPLES]  = float[](
   2.689, // gamma[0] = gamma[1]
   2.689, 2.689, 2.383, 2.133, 2.128, 2.135, 2.113, 2.079, 2.052, 2.018,
   2.003, 1.973, 1.955, 1.921, 1.891, 1.859, 1.817, 1.767, 1.722, 1.683,
   1.627, 1.555, 1.495, 1.402, 1.329, 1.208, 1.073, 0.888, 0.642, 0.289,
   0.289  // gamma[31] = gamma[30]
);

float get_handheld_gamma_for_color(float normalized_color, float gamma[GAMMA_SAMPLES])
{
   float denormalized_color = normalized_color * float(GAMMA_SAMPLES - 1);
   int idx_low = int(floor(denormalized_color));
   int idx_high = int(ceil(denormalized_color));
   float weight = fract(denormalized_color);
   return mix(gamma[idx_low], gamma[idx_high], weight);
}

vec3 handheld_eotf(vec3 color)
{
   float gr = get_handheld_gamma_for_color(color.x, GAMMA_RED);
   float gg = get_handheld_gamma_for_color(color.y, GAMMA_GREEN);
   float gb = get_handheld_gamma_for_color(color.z, GAMMA_BLUE);
   return pow(color, vec3(gr, gg, gb));
}

const mat3 HANDHELD_RGB_LIN_TO_XYZ = mat3(
   0.36664577,  0.38924042,  0.20093478,
   0.23925876,  0.56553733,  0.19520391,
   0.16662815,  0.21931085,  0.93293225
);

const mat3 CAT_BRADFORD_HANDHELD_TO_SRGB = mat3(
    1.02898172,  0.01191075, -0.03488294,
    0.01437052,  1.0014633,  -0.0115351,
   -0.00688464,  0.01152609,  0.8220052
);



// sRGB

const mat3 SRGB_XYZ_TO_RGB_LIN_MTX = mat3(
    3.2406255, -1.5372080, -0.4986286,
   -0.9689307,  1.8757561,  0.0415175,
    0.0557101, -0.2040211,  1.0569959
);

vec3 srgb_oetf(vec3 color)
{
   vec3 linear = 12.92 * color;
   vec3 nonlinear = 1.055 * pow(color, vec3(1.0 / 2.4)) - 0.055;
   bvec3 cond = lessThanEqual(color, vec3(0.0031308));
   return mix(nonlinear, linear, vec3(cond));
}

// end (sRGB)



// Pre-Processing & Post-Processing

vec3 compute_out_of_gamut(vec3 color)
{
   float error = 1.0 / (255.0 * 10.0);
   bool is_out_of_gamut = any(lessThan(color, vec3(0.0 - error))) || any(greaterThan(color, vec3(1.0 + error)));
   color = clamp(color, 0.0, 1.0);
   float grey = (color.x + color.y + color.z) / 3.0;
   vec3 out_of_gamut = vec3(1.0, grey / 2.5, grey / 2.5);
   vec3 non_out_of_gamut = vec3(grey, grey, grey);
   return mix(non_out_of_gamut, out_of_gamut, float(is_out_of_gamut));
}

// end (Pre-Processing & Post-Processing)

void main()
{
   vec4 handheld_rgba = texture(Source, vTexCoord);

   // debug: color scales
   if ((RedScale + GreenScale + BlueScale) > 0.0) {
      handheld_rgba = vec4(
         mix(0.0, vTexCoord.x, RedScale), 
         mix(0.0, vTexCoord.x, GreenScale), 
         mix(0.0, vTexCoord.x, BlueScale), 
         1.0
      );
   }

   // pre processing: quantization (very imprecise DON'T USE IT)
   //handheld_rgba = floor(handheld_rgba * float(1 << BIT_DEPTH)) / float(1 << BIT_DEPTH);

   // 1. handheld colorspace EOTF
   vec3 handheld_linearized_rgb = handheld_eotf(handheld_rgba.rgb);

   // 2. handheld linearized RGB -> handheld XYZ
   vec3 handheld_xyz = vec3(
      (HANDHELD_RGB_LIN_TO_XYZ[0][0] * handheld_linearized_rgb.r) + (HANDHELD_RGB_LIN_TO_XYZ[0][1] * handheld_linearized_rgb.g) + (HANDHELD_RGB_LIN_TO_XYZ[0][2] * handheld_linearized_rgb.b),
      (HANDHELD_RGB_LIN_TO_XYZ[1][0] * handheld_linearized_rgb.r) + (HANDHELD_RGB_LIN_TO_XYZ[1][1] * handheld_linearized_rgb.g) + (HANDHELD_RGB_LIN_TO_XYZ[1][2] * handheld_linearized_rgb.b),
      (HANDHELD_RGB_LIN_TO_XYZ[2][0] * handheld_linearized_rgb.r) + (HANDHELD_RGB_LIN_TO_XYZ[2][1] * handheld_linearized_rgb.g) + (HANDHELD_RGB_LIN_TO_XYZ[2][2] * handheld_linearized_rgb.b)
   );

   // 3. chromatic adaptation (handheld XYZ -> target XYZ)
   vec3 target_xyz = handheld_xyz;
   if (ChromaticAdaptation == 1.0)
      target_xyz = vec3(
         (CAT_BRADFORD_HANDHELD_TO_SRGB[0][0] * handheld_xyz.r) + (CAT_BRADFORD_HANDHELD_TO_SRGB[0][1] * handheld_xyz.g) + (CAT_BRADFORD_HANDHELD_TO_SRGB[0][2] * handheld_xyz.b),
         (CAT_BRADFORD_HANDHELD_TO_SRGB[1][0] * handheld_xyz.r) + (CAT_BRADFORD_HANDHELD_TO_SRGB[1][1] * handheld_xyz.g) + (CAT_BRADFORD_HANDHELD_TO_SRGB[1][2] * handheld_xyz.b),
         (CAT_BRADFORD_HANDHELD_TO_SRGB[2][0] * handheld_xyz.r) + (CAT_BRADFORD_HANDHELD_TO_SRGB[2][1] * handheld_xyz.g) + (CAT_BRADFORD_HANDHELD_TO_SRGB[2][2] * handheld_xyz.b)
      ); 

   // 4. target XYZ -> target linearized RGB
   vec3 target_linearized_rgb = vec3(
      (SRGB_XYZ_TO_RGB_LIN_MTX[0][0] * target_xyz.r) + (SRGB_XYZ_TO_RGB_LIN_MTX[0][1] * target_xyz.g) + (SRGB_XYZ_TO_RGB_LIN_MTX[0][2] * target_xyz.b),
      (SRGB_XYZ_TO_RGB_LIN_MTX[1][0] * target_xyz.r) + (SRGB_XYZ_TO_RGB_LIN_MTX[1][1] * target_xyz.g) + (SRGB_XYZ_TO_RGB_LIN_MTX[1][2] * target_xyz.b),
      (SRGB_XYZ_TO_RGB_LIN_MTX[2][0] * target_xyz.r) + (SRGB_XYZ_TO_RGB_LIN_MTX[2][1] * target_xyz.g) + (SRGB_XYZ_TO_RGB_LIN_MTX[2][2] * target_xyz.b)
   );   

   // 5. target colorspace OETF
   vec3 target_rgb = srgb_oetf(target_linearized_rgb);

   // post processing: out of gamut
   if (DebugOutOfGamut == 1.0)
      target_rgb = compute_out_of_gamut(target_rgb);
   
   FragColor = vec4(target_rgb, handheld_rgba.w);
}
