/* Diffusion equation solver
 * Jose Luis Cercos-Pita (2020)
 *
 * This work is licensed under a GLP v2 License.
 */

// #define SIMPLE_SCHEME
#define COOLING 0.1

uniform sampler2D T;
uniform sampler2D Q;
uniform float dx;
uniform float dy;
uniform float dt;
uniform float diffusion;
uniform float heating;

void main(void) {
    vec2 C0 = gl_TexCoord[0].st;
    vec4 Ti = texture2D(T, C0);
    vec4 Qi = texture2D(Q, C0) - vec4(COOLING);

#ifndef SIMPLE_SCHEME 
    vec4 lapT = -3.0 * Ti;
    for (int i = -1; i <= 1; i++) {
        float ii = float(i);
        float fi = 1.0 - 0.5 * abs(ii);
        for (int j = -1; j <= 1; j++) {
            if ((i == 0) && (j == 0))
                continue;
            float jj = float(j);
            float fj = 1.0 - 0.5 * abs(jj);
            lapT += fi * fj * texture2D(T, C0 + vec2(dx * float(i), dy * float(j)));
        }
    }
#else
    vec4 lapT = -4.0 * Ti;    
    if (C0.x - dx >= 0.0)
        lapT += texture2D(T, C0 - vec2(dx, 0.0));
    if (C0.x + dx <= 1.0)
        lapT += texture2D(T, C0 + vec2(dx, 0.0));
    if (C0.y - dy >= 0.0)
        lapT += texture2D(T, C0 - vec2(0.0, dy));
    if (C0.y + dy <= 1.0)
        lapT += texture2D(T, C0 + vec2(0.0, dy));
#endif

    gl_FragColor = clamp(
        Ti + dt * (heating * Qi + diffusion * lapT), 0.0, 1.0);
} 
