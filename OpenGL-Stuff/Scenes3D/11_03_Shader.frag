
// Shader-ul de fragment / Fragment shader  
 
 #version 400

in vec4 ex_Color;
in vec2 tex_Coord;
out vec4 out_Color;

uniform sampler2D myTexture;


void main(void)
  {
//   out_Color=ex_Color;
	 out_Color = mix(texture(myTexture, tex_Coord), ex_Color, 0.2);
  }
 