float rand(vec2 co, float a, float b)
{
	float c = 43758.5453;
	float dt= dot(co.xy, vec2(a,b));
	float sn= mod(dt, 3.14);
	return fract(sin(sn) * c);
}

void main(void) {
	vec3 noise = vec3(rand(gl_TexCoord[0].st, 12.9898, 78.233),
	                  rand(gl_TexCoord[0].st, 12.9898 * 2.0, 78.233 * 3.0),
	                  0.0);
	gl_FragColor = vec4(normalize(noise), 1.0);
}
