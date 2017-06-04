uniform sampler2D colors;
uniform vec2 vignette;

void main()
{
	vec2 C0 = gl_TexCoord[0].st;
	vec4 color = texture2D(colors, C0);
	float d = distance(C0, vec2(0.5,0.5));

	float value = smoothstep(vignette.x, vignette.y, d);
	gl_FragColor = vec4(color.xyz - vec3(value), color.w);
} 
