/* AMBIGRAM OpenScad Generator */
/* 
 Author: Christophe Garde - 2023.12.20

Instructions : 
 - both texts must be the same length
 - put underscores for an empty letter 
*/
//font="UbuntuMono"; // font name
font1="Gotham Black"; // font name
font2="Segoe UI Symbol"; // font name

text1="SUSTAIN\U01F333";
//text1_fonts=[for(i=[1:len(text1)]) font1];
text1_fonts=[font1,font1,font1,font1,font1,font1,font1,font2];


text2="ABILITY\U01F333";
//text2_fonts=[for(i=[1:len(text2)]) font2];
text2_fonts=[font1,font1,font1,font1,font1,font1,font1,font2];



separate_support=true;
size=30; // font size
width=32; // character width make sure it's large enough to fit otherwise you will have bugs :).
rounded_diam=4; // rounding sphere diameter.
enable_rounding=false; // set to true to have rounded letters (takes longer)
$fn=72;

n=len(text1);

/* Support size */
c_length=width*n*sqrt(2)+10;
c_width=width*1.5;
c_thickness=2;

/*************************************************************/


// bottom support
module support(){
    minkowski(){
    rotate([0,0,45]) translate([-c_width/2,-c_width/2,-c_thickness]) cube([c_length,c_width,c_thickness]);
        translate([0,0,-c_thickness])cylinder(d=10,h=c_thickness);
    }
}

module letter(letter,angle,width,size,font){
    if (letter!="_"){
        rotate([90,0,angle]) linear_extrude(width,center=true) text(letter,size,font,halign="center",valign="bottom");
    }else{
        translate([0,0,size/2]) cube([width,width,size],center=true);
    }
}

// main module : write text at proper position
module writeText(text1,text2,angle){
    for (i=[0:n-1]){
        translate([i*(width+1),i*(width+1),0]) 
        difference(){
            letter(text1[i],0,width,size,text1_fonts[i]);
            difference(){
                translate([0,0,-1]) letter("_",90,width*1.5,size*1.5,""); // this will draw a cube.
                letter(text2[i],90,width*2,size,text2_fonts[i]);
          }
        }
    }
}

// cubes 
module cubes(text){
    for (i=[0:n-1]){
          translate([i*width,i*width,0]) {
            translate([-width/2,-width/2,0]) cube([width,width,size]);
          }
          
    }
}
// merge the 2 texts and remove them from the cubes
module letters(){
    writeText(text1,text2,angle=0);
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

rotate([0,0,-45+45*sin($t*360)])
translate([-(n-1)*width/2,-(n-1)*width/2,0]){
    if (separate_support){
        difference(){
            support();
            translate([0,0,-1]) ambigram();
        }    
        translate([0,0,20]) ambigram();
    }else{
        support();
        translate([0,0,-1]) ambigram();
    }
}