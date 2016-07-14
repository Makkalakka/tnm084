// A simple SL surface shader to render an atmosphere with clouds
surface cloud_surface()
{
	//Colors for the different clouds
	color brightCloud = color(1.0,1.0,1.0);
	color lagomCloud = color(0.8,0.8,0.8);
	color darkCloud = color(0.2,0.2,0.2);
	color opacity = 0.1;
	
	//Create a noisy surface	
	float noisy = noise(noise(noise(2*P)));
	float noisy2 = noise(2*P);

	//Turbulance from SL-example 2004 - Stefan Gustavson
	float turbulence = abs(-1.0 + float noise(point(s*60, t*60, 3.5)));
	turbulence = turbulence * 8.0;

	//Mix colors
	color Cd = mix(brightCloud,darkCloud, noisy);
	color Cd2 = mix(Cd, lagomCloud, turbulence);

	Ci = Cd2 * diffuse(N) * noisy2;
	Oi = noisy * opacity;
}
