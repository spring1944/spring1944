/* Convolution based gradient
 * Jose Luis Cercos-Pita (2020)
 *
 * This work is licensed under a GLP v2 License.
 */

 #ifndef M_PI
    #define M_PI 3.14159265359
#endif
#ifndef iM_PI
    #define iM_PI 0.318309886
#endif

// The kernel length is 4.5, but we are interested in the integer
#define H 5
#define Hf 5.5
#define Hf2 30.25
// CONF = 1 / H^4
#define CONF 0.001092821528584113

// The heatmaps are in general pretty flat, so maybe we can enjoy a
// magnification factor
#define MAGF 15.0

uniform sampler2D heatmap;
uniform float dx;
uniform float dy;

// Wendland kernel
float fij(float q)
{
    const float wcon = 1.09375 * iM_PI;  // 1.09375 = 2*5*7/64
    return wcon * (2.0 - q) * (2.0 - q) * (2.0 - q);
}

void main(void) {
    vec2 C0 = gl_TexCoord[0].st;
    vec2 c_i = texture2D(heatmap, C0).xy;
    float h_i = clamp(c_i.r - c_i.g, 0.0, 1.0);

    vec2 grad_h = vec2(0.0, 0.0);
    for (int i = -H; i <= H; i++) {
        float ii = float(i);
        for (int j = -H; j <= H; j++) {
            if ((i == 0) && (j == 0))
                continue;
            float jj = float(j);
            if ((ii * ii + jj * jj) > Hf2)
                continue;
            vec2 c_j = texture2D(heatmap, C0 + vec2(dx * ii, dy * jj)).xy;
            float h_j = clamp(c_j.r - c_j.g, 0.0, 1.0);
            vec2 r_ij = vec2(ii, jj);
            float q = length(r_ij) / Hf;
            grad_h -= (h_j - h_i) * fij(q) * r_ij;
        }
    }

    gl_FragColor.xy = clamp(MAGF * 0.5 * CONF * grad_h + 0.5, 0.0, 1.0);
    gl_FragColor.zw = vec2(c_i.g, 1.0);
} 
