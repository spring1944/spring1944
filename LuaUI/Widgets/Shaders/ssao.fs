uniform sampler2D normals;
uniform sampler2D depths;
uniform sampler2D texNoise;

uniform mat4 viewMat;
uniform mat4 projectionMat;
uniform mat4 projectionMatInv;
// Spring only let's sending float arrays of 32 components...
uniform float samplesX[32];
uniform float samplesY[32];
uniform float samplesZ[32];
uniform vec2 noiseScale;

#define KERNEL_SIZE 32
#define RADIUS 5.0
#define BIAS 0.2

void main(void) {
	vec2 C0 = gl_TexCoord[0].st;
	float depth = texture2D(depths, C0).x;
	float alpha = texture2D(depths, C0).w;
	// We need the normal in the view-space
	vec3 normal = (viewMat * vec4(texture2D(normals, C0).xyz, 0.0)).xyz;
	// vec3 normal = texture2D(normals, C0).xyz;
	normal = normalize(normal * 2.0 - 1.0);

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

	for(int i = 0; i < KERNEL_SIZE; ++i)
	{
		// get view-space sample position
		vec3 sample = TBN * vec3(samplesX[i],
		                         samplesY[i],
		                         samplesZ[i]);
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

	occlusion = 1.0 - (occlusion / float(KERNEL_SIZE));

	// occlusion = 2.0 * (1.0 - occlusion / float(KERNEL_SIZE));
	// occlusion = occlusion / float(KERNEL_SIZE);

	gl_FragColor = vec4(vec3(occlusion), alpha);
}
