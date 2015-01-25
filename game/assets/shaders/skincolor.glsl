
uniform Image skinMask;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	float mask = Texel(skinMask, texCoord).r;
	vec4 spriteColor = Texel(texture, texCoord);
	return mix(spriteColor, spriteColor * color, mask);
}