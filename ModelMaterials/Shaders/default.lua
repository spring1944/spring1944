return {
vertex = [[
	//#define use_normalmapping
	//#define flip_normalmap
	//#define use_shadows
	%%VERTEX_GLOBAL_NAMESPACE%%
	
	uniform mat4 camera;   //ViewMatrix (gl_ModelViewMatrix is ModelMatrix!)
	uniform vec3 cameraPos;
	uniform vec3 sunPos;
	uniform vec3 sunDiffuse;
	uniform vec3 sunAmbient;
	uniform vec3 etcLoc;
	uniform int simFrame;
	#ifdef flashlights
		varying float selfIllumMod;
	#endif
	//uniform float frameLoc;
	
	#ifdef use_treadoffset
		uniform float treadOffset;
	#endif
	
	//The api_custom_unit_shaders supplies this definition:
	#ifdef use_shadows  
		uniform mat4 shadowMatrix;
		uniform vec4 shadowParams;
	#endif
	
	#ifdef use_vertex_ao
		varying float aoTerm;
	#endif
	varying vec3 cameraDir;
	
	#ifdef use_normalmapping
		varying mat3 tbnMatrix;
	#else
		varying vec3 normalv;
	#endif

	void main(void)
	{
		vec4 vertex = gl_Vertex;
		vec3 normal = gl_Normal;
		
		%%VERTEX_PRE_TRANSFORM%%

		#ifdef use_normalmapping
			vec3 tangent   = gl_MultiTexCoord5.xyz;
			vec3 bitangent = gl_MultiTexCoord6.xyz;
			tbnMatrix = gl_NormalMatrix * mat3(tangent, bitangent, normal);
		#else
			normalv = gl_NormalMatrix * normal;
		#endif

		vec4 worldPos = gl_ModelViewMatrix * vertex;
		gl_Position   = gl_ProjectionMatrix * (camera * worldPos);
		cameraDir     = worldPos.xyz - cameraPos;

		#ifdef use_shadows
			gl_TexCoord[1] =shadowMatrix *gl_ModelViewMatrix*gl_Vertex;
			gl_TexCoord[1].st = gl_TexCoord[1].st * (inversesqrt( abs(gl_TexCoord[1].st) + shadowParams.z) + shadowParams.w) + shadowParams.xy;
		#endif
		#ifdef use_treadoffset
			gl_TexCoord[0].st = gl_MultiTexCoord0.st;
			if (gl_MultiTexCoord0.s < 0.74951171875 && gl_MultiTexCoord0.s > 0.6279296875 && gl_MultiTexCoord0.t > 0.5702890625 && gl_MultiTexCoord0.t <0.6220703125){
				gl_TexCoord[0].s = gl_MultiTexCoord0.s + etcLoc.z;
			}
		#endif
		#ifdef use_vertex_ao
			aoTerm= max(0.4,fract(gl_MultiTexCoord0.s*16384.0)*1.3); // great
		#endif

		#ifndef use_treadoffset
			gl_TexCoord[0].st = gl_MultiTexCoord0.st;
		#endif
		
		#ifdef flashlights
			//float unique_value = sin((gl_ModelViewMatrix[3][0]+gl_ModelViewMatrix[3][2])));
			selfIllumMod = max(-0.2,sin(simFrame *0.063 + (gl_ModelViewMatrix[3][0]+gl_ModelViewMatrix[3][2])*0.1))+0.2;
		#endif
		//float fogCoord = length(gl_Position.xyz); // maybe fog should be readded?
		//fogFactor = (gl_Fog.end - fogCoord) * gl_Fog.scale; //gl_Fog.scale := 1.0 / (gl_Fog.end - gl_Fog.start)
		//fogFactor = clamp(fogFactor, 0.0, 1.0);

		%%VERTEX_POST_TRANSFORM%%
	}
]],

  fragment = [[
//#define use_normalmapping
//#define flip_normalmap
//#define use_shadows

	%%FRAGMENT_GLOBAL_NAMESPACE%%

	uniform sampler2D textureS3o1;
	uniform sampler2D textureS3o2;
	uniform samplerCube specularTex;
	uniform samplerCube reflectTex;

	uniform vec3 sunPos; // is sunDir!
	uniform vec3 sunDiffuse;
	uniform vec3 sunAmbient;
	uniform vec3 etcLoc;
	#ifndef SPECULARMULT
		#define SPECULARMULT 1.0
	#endif
	
	#ifdef use_shadows
		uniform sampler2DShadow shadowTex;
		uniform float shadowDensity;
	#endif
	#ifdef use_vertex_ao
		varying float aoTerm;
	#endif
	uniform vec4 teamColor;
	varying vec3 cameraDir;
	//varying float fogFactor;
	
	#ifdef flashlights
		varying float selfIllumMod;
	#endif
	
	#ifdef use_normalmapping
		varying mat3 tbnMatrix;
		uniform sampler2D normalMap;
	#else
		varying vec3 normalv;
	#endif
	float GetShadowCoeff(vec4 shadowCoors){
		#ifdef use_shadows
			float coeff = shadow2DProj(shadowTex, shadowCoors+vec4(0.0, 0.0, -0.00005, 0.0)).r;
			coeff  = (1.0 - coeff);
			coeff *= shadowDensity;
			return (1.0 - coeff);
		#else
			return 1.0;
		#endif
	}

	float beckmannDistribution(float x, float roughness)
	{
		float NdotH = max(x, 0.0001);
		float cos2Alpha = NdotH * NdotH;
		float tan2Alpha = (cos2Alpha - 1.0) / cos2Alpha;
		float roughness2 = roughness * roughness;
		float denom = 3.141592653589793 * roughness2 * cos2Alpha * cos2Alpha;
		return exp(tan2Alpha / roughness2) / denom;
	}

	float cookTorranceSpecular(vec3 lightDirection,
	                           vec3 viewDirection,
	                           vec3 surfaceNormal,
	                           float roughness,
	                           float fresnel)
	{
		float VdotN = max(dot(viewDirection, surfaceNormal), 0.0);
		float LdotN = max(dot(lightDirection, surfaceNormal), 0.0);

		//Half angle vector
		vec3 H = normalize(lightDirection + viewDirection);

		//Geometric term
		float NdotH = max(dot(surfaceNormal, H), 0.0);
		float VdotH = max(dot(viewDirection, H), 0.000001);
		float x = 2.0 * NdotH / VdotH;
		float G = min(1.0, min(x * VdotN, x * LdotN));

		//Distribution term
		float D = beckmannDistribution(NdotH, roughness);

		//Fresnel term
		float F = pow(1.0 - VdotN, fresnel);

		//Multiply terms and done
		return  G * F * D / max(3.14159265 * VdotN * LdotN, 0.000001);
	}

	void main(void){
		%%FRAGMENT_PRE_SHADING%%

		#ifdef use_normalmapping
			vec2 tc = gl_TexCoord[0].st;
			#ifdef flip_normalmap
				tc.t = 1.0 - tc.t;
			#endif
			vec4 normaltex=texture2D(normalMap, tc);
			vec3 nvTS   = normalize((normaltex.xyz - 0.5) * 2.0);
			vec3 normal = tbnMatrix * nvTS;
		#else
			vec3 normal = normalize(normalv);
		#endif
		vec3 light = max(dot(normal, sunPos), 0.0) * sunDiffuse + sunAmbient;

		vec4 diffuseIn  = texture2D(textureS3o1, gl_TexCoord[0].st);
		vec4 outColor   = diffuseIn;
		vec4 extraColor = texture2D(textureS3o2, gl_TexCoord[0].st);
		vec3 reflectDir = reflect(cameraDir, normal);
		
		#if (DEFERRED_MODE == 0)
			// vec3 specular   = textureCube(specularTex, reflectDir).rgb * extraColor.g * SPECULARMULT;
			float CTS = cookTorranceSpecular(sunPos,
			                                 -normalize(cameraDir),
			                                 normal,
			                                 1.0 - extraColor.g,
			                                 0.8);
			vec3 specular   = sunDiffuse * CTS * SPECULARMULT;
			vec3 reflection = textureCube(reflectTex,  reflectDir).rgb;
		#endif
		#if (DEFERRED_MODE == 1) 
			vec3 specular   = vec3(1.0,1.0,1.0) * extraColor.g * SPECULARMULT;
			vec3 reflection = vec3(0.0,0.0,0.0);
		#endif
		float shadow = GetShadowCoeff(gl_TexCoord[1] + vec4(0.0, 0.0, -0.00005, 0.0));
		light     = mix(sunAmbient, light, shadow);
		specular *= shadow;

		reflection  = mix(light, reflection, extraColor.g); // reflection
		#ifdef flashlights
			extraColor.r =extraColor.r * selfIllumMod;
		#endif
		reflection += (extraColor.rrr); // self-illum

		outColor.rgb = mix(outColor.rgb, teamColor.rgb, outColor.a);

		//#if (DEFERRED_MODE == 0)
			// diffuse + specular + envcube lighting
			// (reflection contains the NdotL term!)
			outColor.rgb = outColor.rgb * reflection + specular;
		//#endif

		outColor.a   = extraColor.a;
		//outColor.rgb = outColor.rgb + outColor.rgb * (normaltex.a - 0.5) * etcLoc.g; // no more wreck color blending

		#ifdef use_vertex_ao
			outColor.rgb=outColor.rgb*aoTerm;
		#endif

		#if (DEFERRED_MODE == 0)
			gl_FragColor = outColor;
		#else
			gl_FragData[0] = vec4((normal + vec3(1.0, 1.0, 1.0)) * 0.5, 1.0);
			gl_FragData[1] = outColor;
			gl_FragData[2] = vec4(specular, extraColor.a);
			gl_FragData[3] = vec4(extraColor.rrr, 1.0);
		#endif

		%%FRAGMENT_POST_SHADING%%
	}
]],

  uniformInt = {
    textureS3o1 = 0,
    textureS3o2 = 1,
    shadowTex   = 2,
    specularTex = 3,
    reflectTex  = 4,
    normalMap   = 5,
    --detailMap   = 6,
  },
  uniform = {
    -- sunPos = {gl.GetSun("pos")}, -- material has sunPosLoc
    sunAmbient = {gl.GetSun("ambient" ,"unit")},
    sunDiffuse = {gl.GetSun("diffuse" ,"unit")},
    shadowDensity = {gl.GetSun("shadowDensity" ,"unit")},
    -- shadowParams  = {gl.GetShadowMapParams()}, -- material has shadowParamsLoc
  },
  uniformMatrix = {
    -- shadowMatrix = {gl.GetMatrixData("shadow")}, -- material has shadow{Matrix}Loc
  },
}
