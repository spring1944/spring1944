uniform sampler2D mapdepths;
uniform sampler2D modeldepths;

void main(void) {
	vec2 C0 = gl_TexCoord[0].st;
	// Take the best depth pixel
	float mapdepth = texture2D(mapdepths, C0).x;
	float modeldepth = texture2D(modeldepths, C0).x;
	float depth, alpha;
	if(mapdepth < modeldepth){
		depth = mapdepth;
	}
	else{
		depth = modeldepth;
	}

	// Discard too far data
	if(depth >= 1.0){
		alpha = 0.0;
	}
	else{
		alpha = 1.0;
	}

	gl_FragColor = vec4(vec3(depth), alpha);
}
