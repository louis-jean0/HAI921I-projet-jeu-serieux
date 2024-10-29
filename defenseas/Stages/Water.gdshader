shader_type canvas_item;

uniform float time;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_UV.xy; // Coordonnées de texture
    uv.y += sin(uv.x * 10.0 + time * 5.0) * 0.05; // Animation de l'eau
    uv.x += cos(uv.y * 10.0 + time * 5.0) * 0.05; // Mouvement horizontal
    vec4 texColor = texture(TEXTURE, uv); // Appliquer la texture
    COLOR = texColor; // Sortie du fragment
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
