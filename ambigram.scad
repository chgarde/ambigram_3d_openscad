/* AMBIGRAM OpenScad Generator */
/* 
 Author: Christophe Garde - 2023.12.20

Instructions : 
 - both texts must be the same length
 - put underscores for an empty letter 
*/
text1="LOUFABILOUB";
text2="MAKERSPACE_";

font="UbuntuMono"; // font name
size=30; // font size
width=24; // character width
rounded_diam=4; // rounding sphere diameter.
enable_rounding=false; // set to true to have rounded letters (takes longer)

n=len(text1);

/* Support size */
c_length=width*n*sqrt(2)+10;
c_width=width*1.5;
c_thickness=5;

/*************************************************************/


// bottom support
module support(){
    minkowski(){
    rotate([0,0,45]) translate([-c_width/2,-c_width/2,-c_thickness]) cube([c_length,c_width,c_thickness]);
        translate([0,0,-c_thickness])cylinder(d=10,h=c_thickness);
    }
}

// main module : write text at proper position
module writeText(text,angle){
    for (i=[0:n-1]){
        if (text[i]!="_"){
        translate([i*width,i*width,0]) 
            rotate([0,0,angle])     
                difference(){
                    translate([-width/2,-width/2,0]) cube([width,width,size]);
                            rotate([90,0,0])
                                linear_extrude(width,center=true) 
                                    text(text[i],size,font,halign="center");
                }
        }
    }
}

// cubes 
module cubes(text){
    for (i=[0:n-1]){
          translate([i*width,i*width,0]) 
            translate([-width/2,-width/2,0])cube([width,width,size]);
    }
}

// merge the 2 texts and remove them from the cubes
module letters(){
    difference(){
        cubes(text1);
        union(){
            writeText(text1,angle=0);
            writeText(text2,angle=90);
        }
    }
}

// add some minkowski to have rounded letters
module ambigram(){
    if (enable_rounding){
        minkowski(){
            letters();
            sphere(d=rounded_diam);
        }
    }else{
        letters();
    }
}


// animate for fun
rotate([0,0,-45+45*sin($t*360)]){
    support();
    ambigram();
}
