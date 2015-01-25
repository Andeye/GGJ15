
uniform Image skinMask;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	float mask = Texel(skinMask, texture_coords).r;
	vec4 spriteColor = Texel(texture, texture_coords);
	return mix(spriteColor, spriteColor * color, mask);
}