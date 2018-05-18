interface_angle=31.72;
//connector_angle=90-interface_angle;

interface_width=20;
interface_height=20;

//groove on interface
interface_groove=1.5;///1.5;

//groove on inside
inner_groove = 2;

//groove on bottom
base_groove = 0;//2;

interface_spacing_width=2;//1;
interface_spacing_height=0;//1;

sides=5;
sides_to_draw = sides;
inner_wall_thickness = 2;
base_wall_thickness =0;//3;

face_width=interface_width+(2*interface_spacing_width);
face_height=interface_height+(2*interface_spacing_height);


connector_height = face_height    * cos(interface_angle);
connector_width  = face_height     * sin(interface_angle);

inner_radius     = (face_width/2) / sin(360/(sides*2));
inner_apothem    = (face_width/2) / tan(360/(sides*2));
//outer_radius   = inner_radius  + connector_width;
//outer_apothem  = inner_apothem + connector_width;
angle            = (360/sides);

//connector_thickness = connector_width+inner_wall_thickness;
//connector_depth = connector_height+interface_groove;
//groove_offset_y=connector_height-interface_groove;//-(cos(interface_angle)*interface_groove);
//groove_offset_x=0;//sin(interface_angle)*interface_groove;

//translate([-15,0,0])
connector();	


module connector(){
	for (i=[0:sides_to_draw-1]){
		rotate([0,0,i*angle]){	
			translate([inner_wall_thickness+inner_apothem,-face_width/2,0]){
                difference(){
										strut_interface();
									color([0,1,0])cutout();
                
									}
										corner_bevel();
								
								//translate([connector_width-(interface_groove/tan(interface_angle)),0,0])rotate([0,-interface_angle,0])color([0,0,1])cube([1.5,20,20]);
			}
		}
	}
}

module strut_interface(){
	id = face_width;
	iw = inner_wall_thickness;
	ch = connector_height;
    cw = connector_width;
	bw = base_wall_thickness;
    
    interface_surface();
    inner_wall_surface();
    base_wall_surface();
    base_bevel_surface();
    module interface_surface(){
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
        [1,4,2],
        [ 1, 0, 5, 4 ],  
        [ 3, 5, 0 ],
        [ 3, 2, 4, 5 ],
        ];	
        polyhedron( interfacePoints, interfaceFaces );
    }
	
    module inner_wall_surface(){
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
    polyhedron( innerWallPoints, innerWallFaces );    
        }
    module base_wall_surface(){
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
    polyhedron( baseWallPoints,  baseWallFaces );
    


    }
    module base_bevel_surface(){
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
    polyhedron( baseBevelPoints, baseBevelFaces );
    }
}




module cutout(){
	  iw = inner_wall_thickness;
	  ch = connector_height;
    cw = connector_width;
	  bw = base_wall_thickness;
    bd = base_groove;
    id = interface_groove/tan(interface_angle);
    mw =interface_spacing_width;
   	fw = face_width-mw;
    ig=inner_groove;
		wh=bw-bd;
    union(){
		if(inner_groove>0){
			inner_wall_cutout();
		}
		if(base_groove>0){
			base_wall_cutout();
		}
		if(interface_groove>0){
			interface_cutout();
    }
		}
    module interface_cutout(){
        
    	interfacePoints = [
            [ cw, fw,  0 ],//2 ->0
            [ cw,  mw,  0 ],//3 - 1
            [  0, fw, ch ],//4 - 2
            [  0,  mw, ch ],	//5 -3
            [ cw, fw,  0-id ],//2 ->0
            [ cw,  mw,  0-id ],//3 - 1
            [  0, fw, ch-id ],//4 - 2
            [  0,  mw, ch-id ]	//5 -3
        ];     
        interfaceFaces = [
            [ 1, 0, 2, 3 ],
            [ 7,6,4,5 ],
            [ 7,6,4,5 ],
            [1, 5, 4, 0],
            [2,6,7,3],
            [4,6,2,0],
            [7,5,1,3]
        ];	
        polyhedron( interfacePoints, interfaceFaces );
		}
	

    module inner_wall_cutout(){
        /*innerWallPoints=[
            [ -iw,  mw,  0 ],
            [ -ig,  mw,  0 ],
            [ -ig, fw,  0 ],
            [ -iw, fw,  0 ],
            [ -iw,  mw, ch ],
            [ -ig,  mw, ch ],
            [ -ig, fw, ch ],
            [ -iw, fw, ch ],
        ]; 
        
        innerWallFaces = [
            [ 1, 0, 3, 2 ],
            [ 4, 0, 1, 5 ],
            [ 5, 1, 2, 6 ],
            [ 6, 2, 3, 7 ],
            [ 3, 0, 4, 7 ],
            [ 7, 4, 5, 6 ]
        ];
        
//        polyhedron( innerWallPoints, innerWallFaces );   
*/
      			//translate([-iw,mw,-bw])
						translate([-iw,mw,-bw])cube([ig,interface_width,bw+ch]);
    }
    module base_wall_cutout(){
/*
    baseWallPoints =[
		[  0, mw, wh ],
		[ cw, mw, wh],
		[ cw, fw, wh],
		[  0, fw, wh ],
		[  0, mw, -bw ],
		[ cw, mw, -bw ],
		[ cw, fw, -bw ],
		[  0, fw, -bw ],
	];
	baseWallFaces =[
		[ 0, 1, 2, 3 ],
		[ 0, 4, 5, 1 ],
		[ 1, 5, 6, 2 ],
		[ 2, 6, 7, 3 ],
		[ 0, 3, 7, 4 ],
		[ 4, 7, 6, 5 ]		
	];
//    polyhedron( baseWallPoints,  baseWallFaces );*/
      			//translate([-iw,mw,-bw])
						//translate([0,0,-bw])
						translate([-iw,mw,-bw])cube([cw+iw,interface_width,bd]);
  


    }
 
}

   module corner_bevel(){
		cw=connector_width;
		ch=connector_height;
		iw=inner_wall_thickness;	
		bw=base_wall_thickness;
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
    
    translate([0,face_width,0]){
        polyhedron( innerWallPoints,  innerWallFaces );	
	if(bw>0){
        polyhedron( baseWallPoints,  baseWallFaces );	
	}    
		polyhedron( bevelPoints, bevelFaces );
        polyhedron( baseBevelPoints, baseBevelFaces );
        
    }
}
