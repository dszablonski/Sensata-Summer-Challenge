shader_type spatial;
render_mode specular_schlick_ggx;


void vertex() {
// Output:0

}

void fragment() {
// Color:2
	//0 = safe
	//1 = caution
	//2 = warning
	// Placeholder for until we are able to integrate the database
	// We'll do some calculations in another script which this shader can 
	// hopefully fetch from.
	int sensor_status = 0;
	
	// Vector for the colour green (safe)
	vec3 safe = vec3(0, 1, 0);
	// Vector for the colour yellow (caution)
	vec3 caution = vec3(1, 1, 0);
	// Vector for the colour red (warning)
	vec3 warning = vec3(1, 0, 0);
	float n_out2p1 = 1.000000;

// Output:0
	if (sensor_status == 0)
	{
		ALBEDO = safe;
	}
	else if (sensor_status == 1)
	{
		ALBEDO = caution;
	}
	else
	{
		ALBEDO = warning;
	}
}

void light() {
// Output:0

}
