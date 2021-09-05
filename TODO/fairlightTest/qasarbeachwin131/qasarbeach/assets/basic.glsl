
//@renderpasses 0,1,2

varying vec2 v_TexCoord0;
varying vec4 v_Color;

//@vertex

attribute vec4 a_Position;
attribute vec2 a_TexCoord0;
attribute vec4 a_Color;

uniform mat4 r_ModelViewProjectionMatrix;

uniform vec4 m_ImageColor;

void main(){

	v_TexCoord0=a_TexCoord0;

	v_Color=m_ImageColor * a_Color;
	
	gl_Position=r_ModelViewProjectionMatrix * a_Position;
}

//@fragment

uniform sampler2D m_ImageTexture0;

void main(){

#if MX2_RENDERPASS==0

	vec4 col = texture2D( m_ImageTexture0,v_TexCoord0 );
//	float mono = (col.r + col.g + col.b) / 0.3;
//	col = vec4( mono, mono, mono, col.a );
//	gl_FragColor = vec4( col.rgb * v_Color.rgb, col.a );
//	gl_FragColor = vec4( v_Color.rgb * mono, mono );

	vec2 m_curve = vec2( 0.6, 0.6 );
	vec2 m_resolution = vec2( 1.1, 1.0 );
	float m_scanline_intensity = 0.5;
	float m_rgb_split_intensity = 0.5;
	float m_brightness = 0.5;
	float m_contrast = 0.5;
	float m_gamma = 0.5;

	// get color for position on screen:
	float bl = 0.03;
	float x = v_TexCoord0.x*(1.0+bl)-bl/2.0;
	float y = v_TexCoord0.y*(1.0+bl)-bl/2.0;
	float x2 = (x-0.5)*(1.0+  0.5*(0.3*m_curve.x)  *((y-0.5)*(y-0.5)));///m_scale.x+0.5-m_translate.x;
	float y2 = (y-0.5)*(1.0+  0.25*(0.3*m_curve.y)  *((x-0.5)*(x-0.5)));///m_scale.y+0.5-m_translate.y;
	vec2 v2 = vec2(x2, y2)+0.5;
	vec4 temp = texture2D( m_ImageTexture0, v2 );
	
	float ymod = mod(gl_FragCoord.y, 4.0);
	if (ymod > 2.0) {
		temp *= 0.65;
	} 

//	gl_FragColor = vec4( temp.rgb, 1.0 );

	// grb splitting and scanlines:
	float cr = sin((x2*m_resolution.x)               *2.0*3.1415) * 0.5+0.5+0.1;
	float cg = sin((x2*m_resolution.x-1.0*2.0*3.1415)*2.0*3.1415) * 0.5+0.5+0.1;
	float cb = sin((x2*m_resolution.x-2.0*2.0*3.1415)*2.0*3.1415) * 0.5+0.5+0.1;
	vec4 temp2 = mix(temp*vec4(cr,cg,cb,1.0),temp,1.0-m_rgb_split_intensity);
	float ck = (sin((y2*m_resolution.y)*2.0*3.1415) +0.5+0.1)*m_scanline_intensity;
	temp2 = temp2*0.9 + temp2*ck*0.4;

	if (v2.x<0.0 || v2.x>1.0 || v2.y<0.0 || v2.y>1.0) {
		gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	}else{
		gl_FragColor = vec4( mix( temp.rgb, temp2.rgb, 0.3 ), 1.0 );
	}
	
	// final color:
//	gl_FragColor = vec4((temp.rgb * v_Color.rgb)*0.9+0.1, v_Color.a);

//	gl_FragColor = vec4( col.rgb, 1.0 );
	
#else
	float alpha=texture2D( m_ImageTexture0,v_TexCoord0 ).a * v_Color.a;
	gl_FragColor=vec4( 0.0,0.0,0.0,alpha );
#endif

}
