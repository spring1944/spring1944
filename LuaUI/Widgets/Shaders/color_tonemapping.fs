uniform sampler2D colors;
uniform float exposure;
uniform float gamma;

mat3 ACESInputMat = mat3(0.59719, 0.35458, 0.04823,
                         0.07600, 0.90834, 0.01566,
                         0.02840, 0.13383, 0.83777);

mat3 ACESOutputMat = mat3( 1.60475, -0.53108, -0.07367,
                          -0.10208,  1.10813, -0.00605,
                          -0.00327, -0.07276,  1.07602);

vec3 RRTAndODTFit(vec3 v)
{
    vec3 a = v * (v + 0.0245786) - 0.000090537;
    vec3 b = v * (0.983729 * v + 0.4329510) + 0.238081;
    return a / b;
}

vec3 ACESFitted(vec3 color)
{
    color = ACESInputMat * color;

    // Apply RRT and ODT
    color = RRTAndODTFit(color);

    color = ACESOutputMat * color;

    // Clamp to [0, 1]
    color = clamp(color, 0.0, 1.0);

    return color;
}

vec3 ACESFilm(vec3 color)
{
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return clamp((color*(a*color+b))/(color*(c*color+d)+e), 0.0, 1.0);
}


void main(void) {
	vec2 C0 = gl_TexCoord[0].st;
	vec4 color = texture2D(colors, C0);

	// Exposure tone mapping
	vec3 mapped = ACESFilm(color.xyz);
	// Gamma correction 
	mapped = pow(mapped, vec3(1.0 / gamma));

	gl_FragColor = vec4(mapped, 1.0);
}
