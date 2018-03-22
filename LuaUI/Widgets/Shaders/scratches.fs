/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
///
/// 2D Noise
/// Author : Ian McEwan, Ashima Arts.
///    Copyright (C) 2011 Ashima Arts. All rights reserved.
/// Distributed under the MIT License.
///    https://github.com/ashima/webgl-noise
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy of
/// this software and associated documentation files (the "Software"), to deal in
/// the Software without restriction, including without limitation the rights to
/// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
/// of the Software, and to permit persons to whom the Software is furnished to do
/// so, subject to the following conditions:
///     1. The above copyright notice and this permission notice shall be included in all
///        copies or substantial portions of the Software.
///     2. Redistributions in binary or minimized form must reproduce the above copyright
///        notice and this list of conditions in the documentation and/or other materials
///        provided with the distribution.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

uniform sampler2D colors;
uniform float threshold;
uniform float randomValue;
uniform float timer;

/// 2D Noise by Ian McEwan, Ashima Arts.
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }
float snoise (vec2 v)
{
    const vec4 C = vec4(0.211324865405187,     // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,     // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,    // -1.0 + 2.0 * C.x
                        0.024390243902439);    // 1.0 / 41.0

    // First corner
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
        + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt( a0*a0 + h*h );
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

    // Compute final noise value at P
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

void main() 
{
    vec2 texCoord = gl_TexCoord[0].st;
    vec2 uv = 0.5 * (texCoord + vec2(1.0));
    vec4 color = texture2D(colors, texCoord);

    float vScratch = 1.0;

    if ( randomValue < threshold )
    {
        // Pick a random spot to show scratches
        float dist = 1.0 / threshold;
        float d = distance(uv,
                           vec2(randomValue * dist, threshold * dist));
        if ( d < 0.5 )
        {
            // Generate the scratch
            float xPeriod = 8.0;
            float yPeriod = 1.0;
            float pi = 3.141592;
            float phase = 37.0 * timer;
            float turbulence = snoise(uv * (5.0 + sin(timer)));
            vScratch = 0.5 + (sin(((uv.x * xPeriod + uv.y * yPeriod + turbulence)) * pi + phase) * 0.5);
            vScratch = clamp((vScratch * 10000.0) + 0.35, 0.0, 1.0);
        }
    }
    
    gl_FragColor = vec4(color.xyz * vScratch, color.w);
}
