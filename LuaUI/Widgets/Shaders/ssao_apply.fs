uniform sampler2D depths;
uniform sampler2D ssao;
uniform sampler2D colors;


#define SSAO_INTENSITY 1.0


void main(void) {
	vec2 C0 = gl_TexCoord[0].st;
	float depth = texture2D(depths, C0).x;
	float occlusion = texture2D(ssao, C0).x;
	vec4 orig = texture2D(colors, C0);

	if(depth >= 0.999){
		// Discard "background pixels"
		occlusion = 1.0;
	}
	else{
		// Rescale the occlusion factor
		occlusion = occlusion * SSAO_INTENSITY + (1.0 - SSAO_INTENSITY);
	}

	// Apply the occlusion
	gl_FragColor = vec4(occlusion * orig.xyz, orig.w);
}
