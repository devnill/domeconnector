connector_angle=31.72;
face_size=20;
sides=5;
sides_to_draw = sides;

connector_height = face_size     * sin(connector_angle);
connector_width  = face_size     * cos(connector_angle);
inner_radius     = (face_size/2) / sin(360/(sides*2));
inner_apothem    = (face_size/2) / tan(360/(sides*2));
outer_radius     = inner_radius  + connector_width;
outer_apothem    = inner_apothem + connector_width;
angle            = (360/sides);


assemble_connector();

module assemble_connector(){
	connector();	
}

module connector(){
	for (i=[0:sides_to_draw-1]){
		rotate([0,0,i*angle]){	
			translate([inner_apothem,-face_size/2,0]){
				strut_interface();
				translate([0,face_size,0]){corner_bevel(angle);}
				
			}
		}
	}
}

module strut_interface(){
	points = [
  	[0,0,0],//0 
    [0,face_size,0],//3
	 	[connector_width,face_size,0],//2 
		[connector_width,0,0],//1 	  
		[0,face_size,connector_height],
		[0,0,connector_height]	
	];     
	faces = [
  	[0,1,2,3],
  	[0,5,1],
  	[1,5,4,2],
	  [2,4,3],  
		[3,4,5,0]
	];	
	polyhedron( points, faces );		
}

module corner_bevel(){
	
	cw=connector_width;
	ch=connector_height;
	ax = sin(angle) * connector_width;
	ay = sqrt(pow(connector_width,2) - pow(ax,2)); 
	
	points = [
  	[  0,  0,  0 ],//0 - inside bottom
  	[ cw,  0,  0 ],//1 - front corner
  	[ ay, ax,  0 ],//2 - side corner
  	[  0,  0, ch ] //3 - inside top
	]; 
    
	faces = [
  	[0,1,2],  // right
  	[0,3,1],  // left
		[1,3,2],// top
	  [0,2,3],  // bottom
	]; 
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
