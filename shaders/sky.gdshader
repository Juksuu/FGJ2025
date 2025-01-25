shader_type canvas_item;

uniform sampler2D minTex;
uniform sampler2D maxTex;

uniform float minHeight;
uniform float maxHeight;

uniform float currentHeight;

void fragment() {
	vec4 minColor = texture(minTex, UV);
	vec4 maxColor = texture(maxTex, UV);
	
	float mixValue = clamp(mix(minHeight, maxHeight, currentHeight), 0, 1);
	COLOR = mix(minColor, maxColor, mixValue);
}