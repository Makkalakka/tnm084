#include "voronoi.sl"
#include <aqsis/math/math.h>

// A simple SL displacement shader to render a planet-like sphere
displacement planet_displacement(output varying float water = 0.0, mountainAngle = 0.0, eqDistance = 0.0, height = 0.0;) 
{
	float elevation = noise(2*P)-0.5;
	elevation += 0.7*(noise(4*P)-0.5);
	elevation += 0.4*(noise(8*P)-0.5);
	elevation += 0.13*(noise(16*P)-0.5);
	elevation += 0.06*(noise(32*P)-0.5);
	elevation += 0.04*(noise(64*P)-0.5);
	
	water = 0.0;
	mountainAngle = 0.0;
	float orDistance = 0.0;
	eqDistance = 0.0;
	height = 0.0;
	
	//at what height the water should appear
	float waterElevation = 0.02;
	float forestElevation = 0.24;
	
	//Pointiness of the mountains
	float pointiness = 1.7;
	
	//Cellular noise which should creates craters and/or volcanoes
	point Ptex = transform("object", P);
	float freq = 8.0;
	float jitter = 0.8;
	float f1, f2;
	point pt1, pt2;
	voronoi_f2_3d(Ptex, freq, jitter, f1, f2, pt1, pt2);
	float f = f2-f1;

	//Reduces both the amplitude and the frequency of craters
	elevation += 0.12*smoothstep(0.2, 0.7, f1);
	
	//High mountains should be pointier, a hardcoded erosion
	if(elevation > forestElevation)
	{
		float riseFactor = (elevation - forestElevation)*pointiness;
		elevation += riseFactor*(noise(30*P)-0.5);
		elevation += riseFactor*0.5*(noise(60*P)-0.5);
	}
	
	//Water at elevations lower than waterElevation
	if(elevation <= waterElevation) //water to swim in
	{
		water = 1.0;
		elevation = waterElevation + 0.02*(noise(100*P)-0.5);
	}
	
	//Hardcoded origin of the sphere
	point origin = (0.0, 0.0, 5.0);
	
	//The length from the origin to the sea
	point seaLvl = (P + N * 0.1 * waterElevation) - origin;
	float seaHeight = length(seaLvl);
	
	P = P + N * 0.1 * elevation;
	
	//Distance from the origin to the current position
	point pDist = P - origin;
	
	//Altitude of surface
	orDistance = length(pDist);
	
	//Colder at north and south poles, a value from 0.0 -> 1.0
	eqDistance = smoothstep(0.0, 1.0, abs(ycomp(pDist)));
	//eqDistance = clamp(abs(ycomp(pDist))*4, 0.0, 1.0);  //alternate way for the climate, but I think it looks better with smoothstep
	
	//Height on the current altitude
	height = (orDistance - seaHeight)*20; //hardcoded 0.0 to 1.0
	height = clamp(height/1.3, 0.0, 1.0);
	height = height*10000.0;
	
	N = calculatenormal(P);
	
	vector newN = normalize(N);
	
	//Steep cliffs shouldn't have vegetation or ice on it
	mountainAngle = 1.0 - abs((newN . pDist)/(sqrt(pDist . pDist)*sqrt(newN . newN)));
	//Makes the steep cliffs color increase faster with the angle
	mountainAngle = clamp(mountainAngle*5.0, 0.0, 1.0);
}

/*
	//usefull code that i want to hoard
	
	elevation = max(elevation, 0.0); // Clip negative values to zero
	
	if (elevation >= sandElevation && elevation <= forestElevation) 
	{
		forest = 1.0;
	}
	else if(elevation >= waterElevation && elevation <= sandElevation) //sand at the beach
	{
		sand = 1.0;
	}
	else if(elevation <= waterElevation) //water to swim in
	{
		water = 1.0;
		elevation = waterElevation + 0.02*(noise(100*P)-0.5);
	}
	else if(elevation >= forestElevation && elevation <= iceElevation)
	{
		cliff = 1.0;
	}
	else  //Ice at high elevations
	{
		ice = 1.0; //kanske onödig
	}
	
*/
