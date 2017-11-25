uniform sampler2D normals;
uniform sampler2D depths;
uniform sampler2D texNoise;

uniform mat4 viewMat;
uniform mat4 projectionMat;
uniform mat4 projectionMatInv;
// Spring only let's sending float arrays of 32 components...
uniform mat4 samplesX;
uniform mat4 samplesY;
uniform mat4 samplesZ;
uniform vec2 noiseScale;

#define RADIUS 5.0
#define BIAS 0.05

void main(void) {
	vec2 C0 = gl_TexCoord[0].st;
	float depth = texture2D(depths, C0).x;
	float alpha = texture2D(depths, C0).w;
	// We need the normal in the view-space. That's in fact a problem... First,
	// we need to recover the real world vector expanding the components, which
	// has been conveniently rescaled to [0-1] interval float values. Otherwise,
	// the view-space transformation will allways fail. e.g. Let's consider the
	// world-space normal (-1, 0, 0), which is contracted to (0, 0, 0), such
	// that it does not matters the rotation matrix we apply, it will wrongly
	// remain unaltered.
	// After that, we must transform the vector to the view-space. However,
	// we should use gl_NormalMatrix, non-provided by spring. Fortunately, such
	// matrix can be computed as transpose(inverse(gl_ModelViewMatrix)), where
	// inverse(gl_ModelViewMatrix) is provided by spring. Even though GLSL 1.10
	// does not provide transpose method, we can use the following matrix vector
	// multiplication feature: transpose(M).v = v * M
	vec3 normal = texture2D(normals, C0).xyz * 2.0 - 1.0;
	normal = (vec4(normal, 0.0) * viewMat).xyz;

	// Get the fragment view-space coordinates
	vec4 viewPos = vec4(vec3(C0, depth) * 2.0 - 1.0, 1.0);
	viewPos = projectionMatInv * viewPos;
	viewPos.xyz = viewPos.xyz / viewPos.w;

	// Compute the kernel (samples) rotation matrix
	vec3 rvec      = texture2D(texNoise, C0 * noiseScale).xyz;
	vec3 tangent   = normalize(rvec - normal * dot(rvec, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 TBN       = mat3(tangent, bitangent, normal);

	float occlusion = 0.0;

	for(int i = 0; i < 4; ++i)
	{
	for(int j = 0; j < 4; ++j)
	{
		// get view-space sample position
		vec3 sample = TBN * vec3(samplesX[i][j],
		                         samplesY[i][j],
		                         samplesZ[i][j]);
		sample = viewPos.xyz + sample * RADIUS;

		// Come back to screen space to request the sample depth
		vec4 offset = vec4(sample, 1.0);
		offset      = projectionMat * offset;
		offset.xy  /= offset.w;
		offset.xy   = offset.xy * 0.5 + 0.5;

		// Get the sample depth
		float sampleDepth = texture2D(depths, offset.xy).x;

		// Get its view-space coordinates
		vec4 samplePos = vec4(vec3(offset.xy, sampleDepth) * 2.0 - 1.0, 1.0);
		samplePos = projectionMatInv * samplePos;
		samplePos.xyz = samplePos.xyz / samplePos.w;

		// Check that the sample is close enough
		// float rangeCheck = abs(viewPos.z - samplePos.z) < RADIUS ? 1.0 : 0.0;
		float rangeCheck = smoothstep(0.0, 1.0, RADIUS / abs(viewPos.z - samplePos.z));
		// float rangeCheck = 1.0;

		// Occlude along the normal direction
		// occlusion += (dot(samplePos.xyz - sample.xyz, normal) > BIAS ? 1.0 : 0.0) * rangeCheck;

		// And accumulate oclussion
		occlusion += (samplePos.z >= sample.z + BIAS ? 1.0 : 0.0) * rangeCheck;
	}
	}

	occlusion = 1.0 - (occlusion / 16.0);

	gl_FragColor = vec4(vec3(occlusion), alpha);
}
