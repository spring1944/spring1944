uniform sampler2D src;
uniform vec2 texelSize;

#define RADIUS 4

void main(void) {
	vec2 C0 = gl_TexCoord[0].st;

	vec3 result = vec3(0.0);
	float size = 0.0;
	for (int x = -RADIUS; x < RADIUS; ++x) 
	{
		for (int y = -RADIUS; y < RADIUS; ++y) 
		{
			vec2 offset = vec2(float(x), float(y)) * texelSize;
			vec4 texel = texture2D(src, C0 + offset);
			result += texel.xyz * texel.w;
			size += texel.w;
		}
	}
	if(size > 0.0){
		gl_FragColor.xyz = result / size;
		gl_FragColor.w = texture2D(src, C0).w;
	}
	else{
		gl_FragColor = texture2D(src, C0);
	}
}
