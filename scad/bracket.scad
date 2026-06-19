use <MCAD/boxes.scad>
$fa = 1;
$fs = 0.4;
$fn = 100;

include <hardware.scad>

// filespec = "../svg/altjazzark-logo-outline.svg";

// The bass clarinet
inst_diameter = 41.0;
inst_radius = inst_diameter/2;
inst_height = 240;
inst_key_distance_max = 78.0 - inst_radius;
inst_key_distance_min = 58.9 - inst_radius;

color("brown") { 
    translate([0, 0, -inst_height/2])
        linear_extrude(height=inst_height)
            circle(inst_diameter/2);
}   

//  The hardware
color("grey") { 
    translate([0, inst_radius*-1, 0])
    hardware();
}   


// //  The bracket 
logo_aspect = 1227.8/610.6;
logo_height = 14; // 610.6
logo_width = 14 * logo_aspect;

wheel_radius = inst_radius*2.2;
side_tilt = -22.5;
forward_tilt = 10;
arc = 360;

// cover_width = 400;
// cover_height = 2200;
// cover_depth = 600;
// cover_radius = 50;
// cover_translate = cover_height/2;


// module wheel(w, h, yTrans, zTrans, xTilt, zTilt, arc, xTrans) {
//     translate([0, yTrans, zTrans])
//         rotate([xTilt, 0, zTilt]) 
//             rotate_extrude(angle=arc) {
//                 translate([xTrans, 0])
//                 rotate([0, 180, 90])
//                 resize([w, h])
//                 import(filespec, center = true, $fn = 100);
//             };
// }

// color("yellow") { 

    
//     difference() {
//         wheel( 
//             logo_width, 
//             logo_height, 
//             (wheel_radius * cos(forward_tilt)) - (inst_radius + cover_depth), 
//             hw_height*0.25, 
//             side_tilt, 
//             forward_tilt, 
//             arc, 
//             wheel_radius
//         );

//         translate([0, -wheel_radius, -hw_height*0.5])
//             cube([wheel_radius*1.2, wheel_radius*2.6, hw_height*1.8]);
//     }
    
    
//     translate([0, -(inst_radius + cover_depth/2), cover_translate])
//         roundedBox(size=[cover_width, cover_depth, cover_height],radius=cover_radius,sidesonly=false);
// }
