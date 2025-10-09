#version 450

layout(set = 0, binding = 0, std140) uniform UBO
{
   mat4 MVP;
};

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
layout(binding = 2) uniform sampler2D LUT;

const int BIT_DEPTH = 5;

void main()
{
   vec4 src_color = texture(Source, vTexCoord);
   ivec3 rgb = ivec3(floor(src_color * ((1 << BIT_DEPTH) - 1.0))); 
   ivec2 pixel_coords = ivec2((rgb.b * ((1 << BIT_DEPTH))) + rgb.r, rgb.g);
   FragColor = texelFetch(LUT, pixel_coords, 0);
}

