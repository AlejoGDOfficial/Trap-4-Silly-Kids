#pragma header

uniform float red;
uniform float blue;
uniform float green;

uniform float offset;

uniform float time;

uniform float factor;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    
    uv.x += sin((time / 10 + uv.y) * 200) * 0.001 * factor;
    
    vec4 color = vec4(
        texture2D(bitmap, uv).r,
        texture2D(bitmap, uv - offset).g,
        texture2D(bitmap, uv + offset).b,
        1.0
    );
    
    color.r *= red;
    color.g *= green;
    color.b *= blue;
    
    gl_FragColor = color; 
}