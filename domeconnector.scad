
//connector_angle=31.72;
connector_angle=45;
face_size=20;
sides=5;

connector_height = face_size     * sin(connector_angle);
connector_width  = face_size     * cos(connector_angle);
inner_radius   = (face_size/2) / sin(360/(sides*2));
inner_apothem  = (face_size/2) / tan(360/(sides*2));
outer_radius   = inner_radius  + connector_width;
outer_apothem  = inner_apothem + connector_width;
angle=(360/sides);
sides_to_draw = sides;


assemble_connector();

module assemble_connector(){
	connector();	
}

module connector(){
	for (i=[0:sides_to_draw-1]){
		rotate([0,0,i*angle]){	
			color("orange"){corner_bevel(angle);}
			color("red"){strut_interface();}
		}
	}
	//color("yellow"){center_area();}
}
	
module strut_interface(){
	translate([-inner_apothem,-face_size/2,connector_height]){
		rotate([0,90,90]){
			linear_extrude(height=face_size){
				polygon([
  				[0,              0            ],
    			[connector_height, 0            ],
    			[connector_height, connector_width]
  			]);
			}
		}
	}
}

module corner_bevel(angle){
	ax = sin(angle) * connector_width;
	ay = sqrt(pow(connector_width,2) - pow(ax,2)); 
	points = [
  	[  0,               0,                0 ],//0 - inside bottom
  	[  0, connector_width,                0 ],//1 - front corner
  	[ ax,              ay,                0 ],//2 - side corner
  	[  0,               0, connector_height ] //3 - inside top
	]; 
    
	faces = [
  	[2,3,0],  // left
  	[0,3,1],  // right
  	[1,3,2],// left
	  [0,1,2],  // bottom

	]; 
  translate([-inner_apothem,face_size/2,0])rotate([0,0,90])
	polyhedron( points, faces );	
}

	

module center_area(){
	if(sides%2==0){
		rotate([0,0,360/(sides*2)])linear_extrude(height=connector_height)circle(r=inner_radius,$fn=sides);
	}
	else{
		linear_extrude(height=connector_height)circle(r=inner_radius,$fn=sides);	
	}	
}