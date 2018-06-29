
// Shader-ul de fragment / Fragment shader  
 
 #version 400

in vec4 ex_Color;
uniform int codCol;
 
out vec4 out_Color;

void main(void)
{
	if ( codCol == 0 )
		out_Color = ex_Color;
	if ( codCol == 1 )
		out_Color = vec4 (0.0, 0.0, 1.0, 0.0);
	if ( codCol == 2 )
		out_Color = vec4 (1.0, 0.0, 0.0, 0.0);
	if ( codCol == 3 )
		out_Color = vec4 (0.0, 1.0, 0.0, 0.0);
	if ( codCol == 4)
		out_Color = vec4 (0.0, 0.2, 0.0, 0.0);
	if ( codCol == 5 )
		out_Color = vec4 (0.4, 0.4, 0.3, 0.0);
		
	if ( codCol == 6 )
		out_Color = vec4 (0.4, 0.4, 0.8, 0.0);
	if ( codCol == 7 )
		out_Color = vec4 (1.0, 1.0, 0.0, 0.0);
	if ( codCol == 8 )
		out_Color = vec4 (0.8, 0.8, 0.8, 0.0);
	if ( codCol == 9 )
		out_Color = vec4 (0.0, 1.0, 1.0, 0.0);
	if ( codCol == 10 )
		out_Color = vec4 (1.0, 0.0, 0.0, 0.0);

	if ( codCol == 11 )
		out_Color = vec4 (0.0, 0.0, 0.0, 0.0);
	if ( codCol == 12 )
		out_Color = vec4 (0.4, 1.0, 0.0, 0.0);
	if ( codCol == 13 )
		out_Color = vec4 (0.2, 0.2, 0.2, 0.0);
	if ( codCol == 14 )
		out_Color = vec4 (0.5, 0.2, 0.9, 0.0);
	if ( codCol == 15 )
		out_Color = vec4 (1.0, 0.4, 0.0, 0.0);
	if ( codCol == 16 )
		out_Color = vec4 (1.0, 1.0, 1.0, 0.0);
}
 