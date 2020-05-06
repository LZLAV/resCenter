#version 300 es
precision mediump float;
uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

const float cornerRadius = 10.0;

void main() {
  vec4 c = texture2D(tex, gl_TexCoord[0].xy);
  if (invert_color)
    c = vec4(vec3(c.a, c.a, c.a) - vec3(c), c.a);
  c *= opacity;

  vec2 windowSize = textureSize(tex, 0);
  vec2 windowCoords = gl_TexCoord[0].xy * windowSize;
  vec2 cornerDistance = min(windowCoords, windowSize - windowCoords);
  float cornerAlpha = 1.0;
  if (max(cornerDistance.x, cornerDistance.y) <= cornerRadius) {
    cornerAlpha = cornerRadius - distance(cornerDistance, vec2(cornerRadius, cornerRadius));
  }
  c *= clamp(cornerAlpha, 0.0, 1.0);

  gl_FragColor = c;
}
