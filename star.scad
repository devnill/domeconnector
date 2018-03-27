sides= 5;
bracket_angle=0;//31.72 for 1v
bracket_width = 20;
bracket_length = 60;
hole_spacing = 30;
hole_diameter = 5.1;
hole_count = 2;
hole_spacing = bracket_width*1.25;
hole_offset  = -bracket_width/2;
bracket_thickness=2;

angle = 360/sides;
inner_radius = ((bracket_width/2)/sin(angle/2));
bracket_offset=cos(angle/2)*inner_radius;

//Example usage: 
	bracket(5);
	translate([0,-130])bracket(4);

module bracket(arms){
	union(){
		linear_extrude(bracket_thickness){
			rotate([0,0,-90*((sides%2))])circle($fn=sides, r=inner_radius);
		}
		for(r=[1:arms]){
			rotate([0,0, r*angle])translate([0,bracket_offset])bracket_arm();
		}
	}
}

module bracket_arm(){
	rotate([bracket_angle, 0,0]){
	{linear_extrude(height=bracket_thickness){
	difference(){
		translate([-bracket_width/2,0])square([bracket_width, bracket_length]);
		union(){
			for(h=[0:hole_count-1]){
				translate([0,bracket_length+hole_offset]){
					translate([0,-h*hole_spacing])circle(d=hole_diameter, $fn=50);	
				}
			}
		}
	}
}
}
}
}