//aqsl planet_surface.sl, aqsl planet_displacement.sl, aqsis planet.rib

// A simple SL surface shader to render a planet-like sphere
surface planet_surface()
{
	float water = 0.0;
	float mountainAngle = 0.0;
	float eqDistance = 0.0;
	float height = 0.0;
	
	//colors for all the elements
	color forestcolor = color(0.4, 0.6, 0.2); //dark green
	color icecolor = color(0.95, 0.95, 1.0);  //light gray
	color sandcolor = color(0.92, 0.78, 0.68);  //beige sand
	color watercolor = color(0.2, 0.2, 0.8);  //blue water
	color cliffcolor = color(0.55,0.35,0.25);  //a red color to show the impact of the mountainangle: color(1.0,0.0,0.0); // brown cliffs
	color Cd;
	
	// Message passing between the displacement and surface shader
	displacement("water", water);
	displacement("mountainAngle", mountainAngle);
	displacement("eqDistance", eqDistance);
	displacement("height", height);
	
	//The temperature defines the color of the surface
	//The first float is the temperature in Celsius of the equator
	//The temperature should decrease towards the poles at the rate of the second float
	float temperature = 60.0 - eqDistance * 60.0;
	
	//The temperature decreases with the float beneeth for each 1000 meters
	temperature = temperature -8.5*height/1000.0; //-6.5 is the most realistic value if standing on our planet
	
	//Sand should appear at temperatures higher than 35 celsius
	float sandDensity = smoothstep(35.0, 45.0, temperature);
	//Forests are grown at temperatures from 5 to 45 celcius
	float forestDensity = smoothstep(5.0, 15.0, temperature) - smoothstep(35.0, 45.0, temperature);
	//Cliffs appear at temperatures from -5.0 to 15 celcius
	float cliffDensity = smoothstep(-5.0, 5.0, temperature) - smoothstep(5.0, 15.0, temperature);
	//Ice appear at temperatures under 5.0 celcius (because i like ice)
	float iceDensity = 1.0 - smoothstep(-5.0, 5.0, temperature);
	
	if(water == 1.0)
	{
		Ci =  watercolor * diffuse(N);
	}
	else
	{
		sandcolor = mix(sandcolor, cliffcolor, mountainAngle);
		forestcolor = mix(forestcolor, cliffcolor, mountainAngle);
		icecolor = mix(icecolor, cliffcolor, mountainAngle);
		Ci = (sandcolor*sandDensity + forestcolor*forestDensity + cliffcolor*cliffDensity + icecolor*iceDensity) * diffuse(N);
	}
}

/*
	//usefull code that i want to hoard
	
	coldTemperature = abs(ycomp(eqDistance))/coldClimate;
	coldTemperature = clamp(coldTemperature, 0.0, 1.0);
	
	//Where some deserts should appear, which is the inverse to the cold temperature (and also not too close to the equator?)
	hotTemperature = clamp((1.0 - coldTemperature - 0.8)*5*orDistance, 0.0, 1.0);
	
	//more intense climate
	coldTemperature = clamp((coldTemperature - 0.5)*5*orDistance, 0.0, 1.0);
	
	if(ice == 1.0)	//remake with temperature instead?!?!
	{
		cliffcolor = mix(cliffcolor, icecolor, coldTemperature*0.5);
		Cd =  mix(icecolor, cliffcolor, mountainAngle);
	}
	else if(sand == 1.0)
	{
		Cd = mix(sandcolor, icecolor, hotTemperature);
	}
	else if(water == 1.0)
	{
		Cd =  watercolor - color(0.4*noise(80*P),0.4*noise(80*P),0.1*noise(80*P)); //a bit noisy water GÖR OM?!!?!
		//Cd =  mix(watercolor, icecolor, round(coldTemperature)); //hur skall det definieras??
	}
	else if(forest == 1.0)
	{
		forestcolor = mix(forestcolor, sandcolor, hotTemperature);
		forestcolor = mix(forestcolor, icecolor, coldTemperature);
		Cd = mix(forestcolor, cliffcolor, mountainAngle);  // if(mountainAngle == 0) cliffcolor = false;
	}
	else if(cliff == 1.0)
	{
		cliffcolor = mix(cliffcolor, icecolor, coldTemperature*0.5);
		Cd = mix(cliffcolor, icecolor, coldTemperature);
		//Cd = cliffcolor;  // if(mountainAngle == 0) cliffcolor = false;
	}
	
	Ci = Cd * diffuse(N); // * 5 * noise(7*P)-0.5;  //AWESOME DISCO planet!
*/
