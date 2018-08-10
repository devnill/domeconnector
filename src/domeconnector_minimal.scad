connector_angle=90-31.72;

interface_width=20;
interface_height=20;
interface_depth=2;

interface_spacing_width=1;
interface_spacing_height=1;

sides=5;
sides_to_draw = 3;//sides;
inner_wall = 0;
base_wall=0;

face_width=interface_width+(2*interface_spacing_width);
face_height=interface_height+(2*interface_spacing_height);

connector_height = face_width     * sin(connector_angle);
connector_width  = face_width     * cos(connector_angle);
inner_radius     = (face_width/2) / sin(360/(sides*2));
inner_apothem    = (face_width/2) / tan(360/(sides*2));
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
			translate([inner_wall+inner_apothem,-face_width/2,0]){
			  strut_interface();
                rotate([0,connector_angle,0])/*translate([connector_width-interface_width,interface_spacing_width, -interface_depth])*/cube([
                interface_width, 
                interface_height,
                interface_depth]);
			  //corner_bevel(angle);	
			}
		}
	}
}

module strut_interface(){
	id = face_width;
	iw = inner_wall;
	ch = connector_height;
  cw = connector_width;
	bw = base_wall;
	interfacePoints = [
  	[  0,  0,  0 ],//0 
    [  0, id,  0 ],//1
	 	[ cw, id,  0 ],//2 
		[ cw,  0,  0 ],//3 	  
		[  0, id, ch ],//4
		[  0,  0, ch ]	//5
	];     
	interfaceFaces = [
  	  [ 0, 1, 2, 3 ],
  	  [ 1, 5, 4, 2 ],  
	  [ 3, 4, 5, 0 ],
	  [ 0, 5, 1 ],
	  [ 2, 4, 3 ],
	];	
	innerWallPoints=[
	  [ -iw,  0,  0 ],
	  [   0,  0,  0 ],
	  [   0, id,  0 ],
	  [ -iw, id,  0 ],
	  [ -iw,  0, ch ],
	  [   0,  0, ch ],
	  [   0, id, ch ],
	  [ -iw, id, ch ],
	]; 
	innerWallFaces = [
		[ 0, 1, 2, 3 ],
		[ 0, 4, 5, 1 ],
		[ 1, 5, 6, 2 ],
		[ 2, 6, 7, 3 ],
		[ 0, 3, 7, 4 ],
		[ 4, 7, 6, 5 ]
	]; 
	baseWallPoints =[
		[ -iw,  0,   0 ],
		[  cw,  0,   0 ],
		[  cw, id,   0 ],
		[ -iw, id,   0 ],
		[ -iw,  0, -bw ],
		[  cw,  0, -bw ],
		[  cw, id, -bw ],
		[ -iw, id, -bw ],
	];
	baseWallFaces =[
		[ 0, 1, 2, 3 ],
		[ 0, 4, 5, 1 ],
		[ 1, 5, 6, 2 ],
		[ 2, 6, 7, 3 ],
		[ 0, 3, 7, 4 ],
		[ 4, 7, 6, 5 ]		
	];
	polyhedron( baseWallPoints,  baseWallFaces );	
	polyhedron( interfacePoints, interfaceFaces );
    polyhedron( innerWallPoints, innerWallFaces );
}



module corner_bevel(){
	translate([0,face_width,0]){
		cw=connector_width;
		ch=connector_height;
		iw=inner_wall;	
		bw=base_wall;
		ox = (cos(angle) * (iw+cw))-iw;
		oy = (sin(angle) * (iw+cw)); 
		ix = (cos(angle) * iw) - iw;
		iy = (sin(angle) * iw);

		points = [
			[ -iw,   0,  0 ], //0
  		[   0,   0,  0 ], //1 
  		[  cw,   0,  0 ], //2 
  		[  ox,  oy,  0 ], //3 
  		[  ix,  iy,  0 ], //4
			[ -iw,   0, ch ], //6
			[   0,   0, ch ], //
			[  ix,  iy, ch ], //4
		]; 
    
		faces = [
  		[ 0, 1, 2, 3, 4 ],
			[ 0, 5, 6, 2, 1 ],
			[ 0, 4, 3 ,7, 5 ],
			[ 2, 6, 7, 3 ],
			[ 5, 7, 6 ],
		];
		
		
		baseWallPoints =[
			[ -iw,  0, -bw ], //0
  		[   0,  0, -bw ], //1 
  		[  cw,  0, -bw ], //2 
  		[  ox, oy, -bw ], //3 
  		[  ix, iy, -bw ], //4
			[ -iw,  0,   0 ], //5
  		[   0,  0,   0 ], //6 
  		[  cw,  0,   0 ], //7 
  		[  ox, oy,   0 ], //8 
  		[  ix, iy,   0 ], //9
			

		];
		
		baseWallFaces =[
			[0,1,2,3,4],
			[0,5,6,7,2,1],
			[2,7,8,3],
			[0,4,3,8,5],
			[5,9,8,7,6],
			[0,4,3,8,5],
		];
		
		polyhedron( baseWallPoints,  baseWallFaces );	
  	polyhedron( points, faces );	
	}
}


