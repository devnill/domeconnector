sides= 5;
bracket_angle=0;//31.72 for 1v
bracket_width = 20;
bracket_length = 100;
hole_spacing = 30;
hole_diameter = 5;
hole_count = 2;
hole_spacing = bracket_width*1.25;
hole_spacings = [10,40,60,90]; 
hole_offset  = -bracket_width/2;
bracket_thickness=2;

bracket_margin=10;

angle = 360/sides;
inner_radius = ((bracket_width/2)/sin(angle/2));
bracket_offset=cos(angle/2)*inner_radius;

apo = (bracket_width/2) / tan(angle/2); 

//Example usage: 
bracket(5);
//translate([500,200]){
//for ( b = [0 : 4] ){
//	translate([0,b*160])bracket(5);
//	translate([360,b*160])bracket(5);
//}

//	for ( b = [0 : 4] ){
//		translate([180,-80])translate([0,b*160])bracket(5);
//		translate([-180,-80])translate([0,b*160])bracket(4);
//		translate([-360,0])translate([0,b*160])bracket(5);

//	}
//}
//	translate([0,200])bracket(4);

module bracket(arms){
	union(){	
//		linear_extrude(bracket_thickness){
		//	rotate([0,0,270*((sides%2))])circle($fn=sides, r=inner_radius);
	//	}
		for(r=[1:arms]){
			rotate([0,0, r*angle])translate([0,bracket_offset-apo])bracket_arm();
		}
	}
}

module bracket_arm(){
	rotate([bracket_angle, 0,0]){
	{
		//linear_extrude(height=bracket_thickness){
	difference(){
		translate([-bracket_width/2,0])square([bracket_width, bracket_length+apo+bracket_margin]);
		union(){
			for(h=hole_spacings){
				translate([0,h+apo+bracket_margin])circle(d=hole_diameter, $fn=50);	
			}
			/*for(h=[0:hole_count-1]){
				translate([0,bracket_length+hole_offset]){
					translate([0,apo+(-h*hole_spacing)])circle(d=hole_diameter, $fn=50);	
				}
			}*/
		}
	//}
}
}
}
}