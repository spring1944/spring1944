uniform sampler2D colors;
uniform float sepiaFactor;

vec3 sepia = vec3(112.0 / 255.0, 66.0 / 255.0, 20.0 / 255.0);

vec3 Overlay (vec3 src, vec3 dst)
{
    // if (dst <= 0.5) then: 2 * src * dst
    // if (dst > 0.5) then: 1 - 2 * (1 - dst) * (1 - src)
    return vec3((dst.x <= 0.5) ? (2.0 * src.x * dst.x) : (1.0 - 2.0 * (1.0 - dst.x) * (1.0 - src.x)),
                (dst.y <= 0.5) ? (2.0 * src.y * dst.y) : (1.0 - 2.0 * (1.0 - dst.y) * (1.0 - src.y)),
                (dst.z <= 0.5) ? (2.0 * src.z * dst.z) : (1.0 - 2.0 * (1.0 - dst.z) * (1.0 - src.z)));
}

void main(void) {
    vec2 C0 = gl_TexCoord[0].st;
    vec4 color = texture2D(colors, C0);

    float gray = (color.x + color.y + color.z) / 3.0;
    vec3 grayscale = vec3(gray);

    vec3 sepiascale = Overlay(sepia, grayscale);

    gl_FragColor = vec4(grayscale + sepiaFactor * (sepiascale - grayscale),
                        color.w);
}
