shader_type canvas_item;

uniform float insanity = 0.0;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);

	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

	color.rgb = mix(color.rgb, vec3(gray), insanity);

	COLOR = color;
}