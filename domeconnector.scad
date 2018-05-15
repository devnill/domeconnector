interface_angle=31.72;
//connector_angle=90-interface_angle;

interface_width=20;
interface_height=20;
interface_depth=1;

interface_spacing_width=0;//1;
interface_spacing_height=0;//1;

sides=5;
sides_to_draw = 5;//sides;
inner_wall = 1;
base_wall =1;

face_width=interface_width+(2*interface_spacing_width);
face_height=interface_height+(2*interface_spacing_height);


connector_height = face_height    * cos(interface_angle);
connector_width  = face_width     * sin(interface_angle);

inner_radius     = (face_width/2) / sin(360/(sides*2));
inner_apothem    = (face_width/2) / tan(360/(sides*2));
//outer_radius     = inner_radius  + connector_width;
//outer_apothem    = inner_apothem + connector_width;
angle            = (360/sides);

//connector_thickness = connector_width+inner_wall;
//connector_depth = connector_height+interface_depth;
//groove_offset_y=connector_height-interface_depth;//-(cos(interface_angle)*interface_depth);
//groove_offset_x=0;//sin(interface_angle)*interface_depth;

translate([-15,0,0])connector();	


module connector(){
	for (i=[0:sides_to_draw-1]){
		rotate([0,0,i*angle]){	
			translate([inner_wall+inner_apothem,-face_width/2,0]){
			  strut_interface();
			  corner_bevel(angle);	
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
		[ 1, 0, 3, 2 ],
		[ 4, 0, 1, 5 ],
		[ 5, 1, 2, 6 ],
		[ 6, 2, 3, 7 ],
		[ 3, 0, 4, 7 ],
		[ 7, 4, 5, 6 ]
	]; 
	
    baseWallPoints =[
		[ 0,  0,   0 ],
		[  cw,  0,   0 ],
		[  cw, id,   0 ],
		[ 0, id,   0 ],
		[ 0,  0, -bw ],
		[  cw,  0, -bw ],
		[  cw, id, -bw ],
		[ 0, id, -bw ],
	];
	baseWallFaces =[
		[ 0, 1, 2, 3 ],
		[ 0, 4, 5, 1 ],
		[ 1, 5, 6, 2 ],
		[ 2, 6, 7, 3 ],
		[ 0, 3, 7, 4 ],
		[ 4, 7, 6, 5 ]		
	];
    
    baseBevelPoints=[
        [ -iw,  0,  0 ],//0
        [   0,  0,  0 ],//1
        [   0, id,  0 ],//2
        [ -iw, id,  0 ],//3
        [   0,  0,  -bw ],//4
        [   0, id,  -bw ],//5
    ];
    baseBevelFaces=[
        [0,1,2,3],
        [2,1,4,5],
        [1,0,4],
        [3,2,5],
        [0,3,5,4]
    ];
    color([1,0,0])polyhedron( baseWallPoints,  baseWallFaces );
    color([0,1,0])polyhedron( interfacePoints, interfaceFaces );
    color([0,0,1])polyhedron( innerWallPoints, innerWallFaces );
    color([1,.5,0])polyhedron( baseBevelPoints, baseBevelFaces );
    
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

		bevelPoints = [
            [   0,   0,  0 ], //0 //interface base center
            [  cw,   0,  0 ], //1 //interface base edge
            [  ox,  oy,  0 ], //2 //outer base edge
            [  ix,  iy,  0 ], //3 //outer base center
			[   0,   0, ch ], //4 //interface top center
			[  ix,  iy, ch ], //5 //outer top center
		]; 
    
		bevelFaces = [
            [1,0,3,2], //bottom
			[ 4, 0, 1], //inner interface side
			[ 2, 3 ,5],// opposite of interface
            [ 4, 1, 2, 5 ], //outside face
			[3, 0, 4, 5]//back
		];
		
        
        
        baseWallPoints = [            
            [   0,   0,  0 ], //0 //interface base center
            [  cw,   0,  0 ], //1 //interface base edge
            [  ox,  oy,  0 ], //2 //outer base edge
            [  ix,  iy,  0 ], //3 //outer base center
            [   0,   0,  -bw ], //0 //interface base center
            [  cw,   0,  -bw ], //1 //interface base edge
            [  ox,  oy,  -bw ], //2 //outer base edge
            [  ix,  iy,  -bw ], //3 //outer base center
        ]; 
		baseWallFaces = [
        [0,1,2,3],
        [0,4,5,1],
        [1,5,6,2],
        [2,6,7,3],
        [0,3,7,4],
        [7,6,5,4]
        ];
        
        innerWallPoints = [ 
			[ -iw,   0,  0 ], //0 //center base corner
            [   0,   0,  0 ], //1 //interface base center
            [  ix,  iy,  0 ], //4 //outer base center
			[ -iw,   0, ch ], //5 //center top corner
			[   0,   0, ch ], //6 //interface top center
			[  ix,  iy, ch ], //7 //outer top center
        ]; 
		innerWallFaces = [
        [1,0,2],
        [0,1,4,3],
        [1,2,5,4],
        [5,2,0,3],
        [5,3,4]
        ];
    
        baseBevelPoints=[
            [ -iw,   0,  0 ], //0 //center base corner
            [   0,   0,  0 ], //1 //interface base center
            [  ix,  iy,  0 ], //4 //outer base center
			[   0,   0,  -bw ], //1 //interface base center
            [  ix,  iy,  -bw ], //4 //outer base center
        ];
        baseBevelFaces=[
        [0,1,2],
        [0,3,1],
        [0,2,4],
        [2,1,3,4],
        [3,0,4]
        ];
        
            color([1,1,0])polyhedron( innerWallPoints,  innerWallFaces );	
          color([1,0,1])polyhedron( baseWallPoints,  baseWallFaces );	
          color([0,1,1])polyhedron( bevelPoints, bevelFaces );
            color([0,1,1])polyhedron( baseBevelPoints, baseBevelFaces );
        
    }
}


        //interface_cutout();    
    
    //}
    //union(){
    //color([0,1,0])
   // base_cutout();            
    //top_cutout
    //inner_cutout();
  //  }
//}
/*
    module base_cutout(){

    //bottom face,
    bottomPoints=[
    [  connector_thickness,  0,  0], //0
    [  connector_thickness, interface_width,  0], //1
    [ connector_thickness-interface_depth, interface_width,  0], //2
    [ connector_thickness-interface_depth,  0,  0], //3
    [  connector_thickness,  0, base_wall], //4
    [  connector_thickness, interface_width, base_wall], //5
    [ connector_thickness-interface_depth, interface_width, base_wall], //6
    [ connector_thickness-interface_depth,  0, base_wall], //7
    ];
    bottomFaces=[
    [0,1,2,3],
    [4,7,6,5],
    [0,4,5,1],
    [1,5,6,2],
    [2,6,7,3],
    [3,7,4,0]
    ];
    //inside face
    //base margin to angle
    //angled face
    //top face
    cutoutPoints=[];
    cutoutFaces=[];
    translate([-inner_wall,interface_spacing_width,-base_wall]){
        
            polyhedron(bottomPoints, bottomFaces);
            
    }
    
}
    module interface_cutout(){
        interfaceCutoutPoints=[
        [connector_width-interface_depth, interface_spacing_width, 0],//0
        [connector_width, interface_spacing_width, 0],//1
        [connector_width, interface_width+interface_spacing_width,0],//2
        [connector_width-interface_depth, interface_width+interface_spacing_width,0],//3

        [-interface_depth,interface_spacing_width,connector_height],
        [0,interface_spacing_width,connector_height],
        [0,interface_width+interface_spacing_width,connector_height],
        [-interface_depth,interface_width+interface_spacing_width,connector_height],
        
        [-interface_depth,interface_spacing_width,connector_height-interface_depth],
        [-interface_depth,interface_spacing_width,connector_height],
        [-interface_depth,interface_width+interface_spacing_width,connector_height],
        [-interface_depth,interface_width+interface_spacing_width,connector_height-interface_depth],
        ];
        interfaceCutoutFaces=[
		[ 0, 1, 2, 3 ],
		[ 0, 4, 5, 1 ],
		[ 1, 5, 6, 2 ],
		[ 2, 6, 7, 3 ],
		[ 0, 3, 7, 4 ],
		[ 4, 7, 6, 5 ]	
        ];
color([1,0,0]){    polyhedron(interfaceCutoutPoints, interfaceCutoutFaces);
    }}

    module inner_cutout(){
        
        interfaceCutoutPoints=[
        [interface_depth-inner_wall,interface_spacing_width,-base_wall],
        [-inner_wall,interface_spacing_width,-base_wall],
        [-inner_wall,interface_width+interface_spacing_width,-base_wall],
        [interface_depth-inner_wall,interface_width+interface_spacing_width,-base_wall],
        [interface_depth-inner_wall,interface_spacing_width,connector_height],
        [-inner_wall,interface_spacing_width,connector_height],
        [-inner_wall,interface_width+interface_spacing_width,connector_height],
        [interface_depth-inner_wall,interface_width+interface_spacing_width,connector_height]
        ];
        interfaceCutoutFaces=[
		[ 0, 1, 2, 3 ],
		[ 0, 4, 5, 1 ],
		[ 1, 5, 6, 2 ],
		[ 2, 6, 7, 3 ],
		[ 0, 3, 7, 4 ],
		[ 4, 7, 6, 5 ]	
        ];
color([1,0,0]){    polyhedron(interfaceCutoutPoints, interfaceCutoutFaces);
        }
}
*/