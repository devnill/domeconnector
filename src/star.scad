sides= 5;
bracket_angle=0;//31.72 for 1v
bracket_width = 20;
bracket_length = 100;
hole_spacing = 30;
hole_diameter = 5;
hole_radius=hole_diameter/2;
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
//echo(apo);

//Example usage: 
//bracket(5); //this creates a 5 sided bracket
//translate([0,apo+bracket_margin])square([20,100]);

translate([140,120]){
for(x=[0:3]){
for(y=[0:8]){
	
	xo=y%2==0?0:150;
	zr=y%2==0?0:180;
	yo=y%2==0?0:-10;
if(y<=5){
	translate([(x*300)+xo,(y*100)+yo])rotate([0,0,zr])bracket(5);	
}
else{
	
	translate([(x*300)+xo,(y*100)+yo])rotate([0,0,zr]){
	//top row of four sided brackets
	bracket(4);
	
		//this is some crap which can generate little template pieces that can be helpful when bending
		/*if(y!=8){
		/*
		difference(){
			//shapes
			union(){
				translate([0,inner_radius*4.5,0])rotate([0,0,90*((sides%2))])rotate([0,0,180]){
					circle($fn=5,r=inner_radius+bracket_margin);
					if(y==7)translate([200,0])circle($fn=5,r=inner_radius+bracket_margin);
				}
				translate([0,inner_radius*7.5,0])rotate([0,0,90*((sides%2))]){
					circle($fn=5,r=inner_radius + bracket_margin);
					if(y==7)translate([-200,0])circle($fn=5,r=inner_radius + bracket_margin);
				}
					//if(x==1){
					//	translate([10,10]){
					//		translate([0,inner_radius*3,0])rotate([0,0,90*((sides%2))])rotate([0,0,180])circle($fn=5,r=inner_radius+bracket_margin);
					//		translate([0,inner_radius*7.5,0])rotate([0,0,90*((sides%2))])circle($fn=5,r=inner_radius + bracket_margin);
					//	}
					//}
			}
			
			//holes

			union(){
	
				if(x%2==0){
					translate([0,inner_radius*4.5,1])rotate([0,0,90*((sides%2))])circle($fn=50,r=9.25);
					//translate([0,inner_radius*5,1])rotate([0,0,90*((sides%2))])circle($fn=50,r=9.25);
					translate([0,inner_radius*7.5,1])rotate([0,0,90*((sides%2))])circle($fn=50,r=9.25);
				}
				else{
					translate([0,inner_radius*4.5,1])rotate([0,0,90*((sides%2))])circle($fn=50,r=3.175);
					translate([0,inner_radius*7.5,1])rotate([0,0,90*((sides%2))])circle($fn=50,r=3.2);
				}
			}
			
		}
	}*/
	}
	}
}
}
}

/*
translate([500,200]){
for ( b = [0 : 4] ){
	translate([0,b*160]){bracket(5);}
	translate([360,b*160])bracket(5);
}

rotate([0,0,180]){
translate([180,850])bracket(4);
	for ( b = [0 : 4] ){
		translate([180,-80])translate([0,b*160])bracket(5);
		translate([-180,-80])translate([0,b*160])bracket(5);
		translate([-360,0])translate([0,b*160])bracket(5);
}
	}
}
for ( b = [0 : 4] ){
	translate([0,b*160]){bracket(5);}
	translate([360,b*160])bracket(5);
}

*/
//	translate([0,200])bracket(4);
corner_radius=7.3;
//echo(corner_radius/sin(angle/2));

	
module inner_corner(arms){
	difference(){
		
			for(r=[1:sides]){
		//	a= sides !=arms && r==1 ? angle*(sides-arms+1) : angle;
			a=angle;
				if((sides!=arms && r != 1 && r!=sides) || sides==arms){
			corner_offset=cos(90-(angle/2))*corner_radius;
			//echo(corner_offset);
				rotate([0,0, (r*a)-a/2]){
					difference(){
					translate([-corner_radius,inner_radius]){
					square([corner_radius*2,(corner_radius/sin(a/2))-corner_offset]);
					//square([5,5]);
					}
				
					translate([0,inner_radius+(corner_radius/sin(a/2)),0]){
						circle($fn=60,r=corner_radius);
						
						}
				}}}
		}
	}
}

module bracket(arms){
	difference(){
	union(){	
		inner_corner(arms);
		
		for(r=[1:arms]){			
			rotate([0,0, r*angle])translate([0,bracket_offset-apo])bracket_arm();
		}
	
	}
	circle(r=hole_radius);
	
}
}

module bracket_arm(){
	rotate([bracket_angle, 0,0]){
	{
		//linear_extrude(height=bracket_thickness){
			
		difference(){
		
		translate([-bracket_width/2,0]){
			square([bracket_width, bracket_length+apo+bracket_margin]);
//			translate([2,bracket_margin+apo,-1])square([bracket_width, bracket_length]);
			
			}
		union(){
			for(h=hole_spacings){
				translate([0,h+apo+bracket_margin])circle(r=hole_radius, $fn=50);	
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