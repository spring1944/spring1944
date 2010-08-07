return {
  vertex = [[
//#define use_normalmapping
//#define flip_normalmap
//#define use_shadows

    uniform mat4 camera;   //ViewMatrix (gl_ModelViewMatrix is ModelMatrix!)
    //uniform mat4 cameraInv;
    uniform vec3 cameraPos;
    uniform vec3 sunPos;
    uniform vec3 sunDiffuse;
    uniform vec3 sunAmbient;
  #ifdef use_shadows
    uniform mat4 shadowMatrix;
    uniform vec4 shadowParams;
  #endif

    varying vec3 cameraDir;
    varying vec3 teamColor;
    varying vec3 light;

  #ifdef use_normalmapping
    varying mat3 tbnMatrix;
  #else
    varying vec3 normal;
  #endif

    void main(void)
    {
      vec3 normal_  = gl_NormalMatrix * gl_Normal;

    #ifdef use_normalmapping
      vec3 tangent   = gl_MultiTexCoord5.xyz;
      vec3 bitangent = gl_MultiTexCoord6.xyz;
      tbnMatrix      = mat3(tangent, bitangent, gl_Normal);
    #else
      normal = normal_;
    #endif

      vec4 worldPos = gl_ModelViewMatrix * gl_Vertex;
      gl_Position   = gl_ProjectionMatrix * camera * worldPos;
      cameraDir     = worldPos.xyz - cameraPos;

    #ifdef use_shadows
      gl_TexCoord[1] = shadowMatrix * worldPos;
      gl_TexCoord[1].st = gl_TexCoord[1].st * (inversesqrt( abs(gl_TexCoord[1].st) + shadowParams.z) + shadowParams.w) + shadowParams.xy;
    #endif

      gl_TexCoord[0].st = gl_MultiTexCoord0.st;
      teamColor = gl_TextureEnvColor[0].rgb;

      float a = max( dot(normal_, sunPos), 0.0);
      light   = a * sunDiffuse + sunAmbient;
    }
  ]],
  fragment = [[
//#define use_normalmapping
//#define flip_normalmap
//#define use_shadows

    uniform sampler2D textureS3o1;
    uniform sampler2D textureS3o2;
    uniform samplerCube specularMap;
    uniform samplerCube reflectMap;

    //uniform sampler2D detailMap;
    uniform sampler2D normalMap;

    uniform vec3 sunPos;
    uniform vec3 sunDiffuse;
    uniform vec3 sunAmbient;

  #ifdef use_shadows
    uniform sampler2DShadow shadowMap;
    uniform float shadowDensity;
  #endif

    varying vec3 cameraDir;
    varying vec3 teamColor;
    varying vec3 light;

  #ifdef use_normalmapping
    varying mat3 tbnMatrix;
  #else
    varying vec3 normal;
  #endif

    void main(void)
    {
     #ifdef use_normalmapping
       vec2 tc = gl_TexCoord[0].st;
       #ifdef flip_normalmap
         tc.t = 1.0 - tc.t;
       #endif
       vec3 nvTS  = (texture2D(normalMap, tc).xyz - 0.5) * 2.0;
       vec3 nv_OS = normalize(tbnMatrix * nvTS);
       vec3 normal_ = gl_NormalMatrix * nv_OS;

       float a      = max( dot(normal_, sunPos), 0.0);
       vec3 light_  = a * sunDiffuse + sunAmbient;
     #else
       vec3 normal_  = normalize(normal);
       vec3 light_   = light;
     #endif

       gl_FragColor     = texture2D(textureS3o1, gl_TexCoord[0].st);
       vec4 extraColor  = texture2D(textureS3o2, gl_TexCoord[0].st);
       //vec3 detailColor = texture2D(detailMap, gl_TexCoord[0].st*7.0).rgb;

       vec3 reflectDir = reflect(cameraDir, normal_);
       vec3 specular   = textureCube(specularMap, reflectDir).rgb * extraColor.g * 4.0;
       vec3 reflection = textureCube(reflectMap,  reflectDir).rgb;

     #ifdef use_shadows
       float shadow = shadow2DProj(shadowMap, gl_TexCoord[1]).r;
       shadow      = 1.0 - (1.0 - shadow) * shadowDensity;
       vec3 shade  = mix(sunAmbient, light_, shadow);
       reflection  = mix(shade, reflection, extraColor.g);
       reflection += extraColor.rrr;
       specular   *= shadow;
     #else
       reflection  = mix(light_, reflection, extraColor.g);
       reflection += extraColor.rrr;
     #endif

       gl_FragColor.rgb = mix(gl_FragColor.rgb, teamColor, gl_FragColor.a); //teamcolor
       gl_FragColor.rgb = gl_FragColor.rgb * reflection + specular;
       gl_FragColor.a   = extraColor.a;

       //gl_FragColor.rgb *= detailColor*1.7;
    }
  ]],
  uniformInt = {
    textureS3o1 = 0,
    textureS3o2 = 1,
    shadowMap   = 2,
    specularMap = 3,
    reflectMap  = 4,
    normalMap   = 5,
    --detailMap   = 6,
  },
  uniform = {
    sunPos = {gl.GetSun("pos")},
    sunAmbient = {gl.GetSun("ambient" ,"unit")},
    sunDiffuse = {gl.GetSun("diffuse" ,"unit")},
    shadowDensity = {gl.GetSun("shadowDensity" ,"unit")},
    shadowParams  = {gl.GetShadowMapParams()},
  },
  uniformMatrix = {
    shadowMatrix = {gl.GetMatrixData("shadow")},
  },
}