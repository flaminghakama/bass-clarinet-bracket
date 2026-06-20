include <../lib/BOSL2/std.scad>

$fa = 1;
$fs = 0.4;
$fn = 100;

kis = 0.02;
kiss = kis * 2;

//  The part of the clip on that attaches to our bracket, not part of our model
// * Clip on bottom clamp max height = 12.4
// * Clip on bottom clamp min height = 3.4
// * Clip on width = 12.3


filespec = "../svg/altjazzark-logo-outline.svg";
logo_aspect = 1227.8/610.6;
logo_height = 14;
logo_width = logo_height * logo_aspect;

space_depth = 20.0;
space_height_min = 2.2;
space_height_max = 4.3;
space_peak_width = 4.1;
space_peak_center = 7.5;
space_stroke_width = 1.2;
ssw = space_stroke_width/2;

cap_extent = 4;
space_extent = 30;
transition_extent = 40; 

tilter_radius = logo_width/2 * 1;     
tooth_radius = 1.4;          
tooth_tolerance = 0.2;
tooth_depth = 3;      
teeth = 24;           
bolt_diameter = 6;
joint_extent = tilter_radius * 2;

nut_diameter = 8.8;
nut_height = 2.7;

//  Just a design element to keep the end rounded
module end_cap() {
    translate([space_depth * -1/2, space_extent + cap_extent, 0])
    rotate([90, 0, 0])
    hull() {
        rotate([0, 0, 90])
        linear_extrude(height = kis) {
            logo_profile();
        }


        translate([0, 0, cap_extent]) {
            linear_extrude(height = kis) {
                clipon_space_profile();
            }
        }
    }
}
//end_cap();


//  The part the clip-on attaches to

module clipon_space_profile() {
    space_profile = [
        [ssw, ssw],
        [space_depth - ssw, ssw],
        [space_depth - ssw, space_height_min - ssw],
        [space_peak_center + space_peak_width/2 - ssw, space_height_min - ssw],
        [space_peak_center, space_height_max - ssw],
        [space_peak_center + ssw - space_peak_width/2, space_height_min - ssw],
        [ssw, space_height_min - ssw]
    ];
    offset(r = ssw) {
        translate([-space_depth/2, 0])
            polygon(space_profile);
    }
}

module bracket_clip_on() {
    translate([-space_depth/2, space_extent, 0])
    rotate([90, 0, 0])
    linear_extrude(space_extent)
        clipon_space_profile();
}
//bracket_clip_on();


module logo_profile() {
    translate([0, 0])
    rotate([0, 0, -90])
    resize([logo_width, logo_height])
    import(filespec, center = true, $fn = 100);
}
// logo_profile();

module transition() {
    translate([space_depth * -1/2, 0])
    rotate([90, 0, 0])
    hull() {
        linear_extrude(height = kis) {
            clipon_space_profile();
        }
        
        translate([0, 0, transition_extent]) {
            rotate([0, 0, 90])
            linear_extrude(height = kis) {
                logo_profile();
            }
        }
    }
}
//transition();


// --- Parametric Lock Tilter ---
// Bolt column and 
// Negative Locking Teeth (Female side)
module bottom_tilter(radius=tilter_radius, height=logo_height) {
    translate([space_depth * -1/2, -(radius + transition_extent), 0])
    union() {
        
        cylinder(r=(bolt_diameter/2)+tooth_tolerance, h=height*2, center=true);
        
        for (i = [0 : 360/teeth : 360]) {
            rotate([0, 0, i])
            translate([radius * 0.6, 0, (height/2)-1])
            cylinder(r1=tooth_radius + tooth_tolerance, r2=tooth_tolerance, h=tooth_depth + tooth_tolerance);
        }
    }
}
//bottom_tilter();

module outside_stencil() {
    translate([space_depth * -1/2, -(tilter_radius + transition_extent), -logo_height/2])
    difference() {
        translate([-tilter_radius, -(tilter_radius + kiss), 0])
            cube([tilter_radius*2, tilter_radius*2 + kiss, logo_height]);
        translate([0, 0, -kis])
            cylinder(h=logo_height + kiss, r1=tilter_radius, r2=tilter_radius, center=false);
        translate([-(tilter_radius + kis), 0, -kis])
            cube([tilter_radius*2 + kiss, tilter_radius + kiss, logo_height + kiss]);
    }
}
//outside_stencil();

module nut_stencil() { 
    translate([-space_depth/2, -(transition_extent + tilter_radius), logo_height * -1/2])
        linear_extrude(height = nut_height + ssw) {
            circle(d = nut_diameter, $fn = 6);
        }
}
//nut_stencil();

module joint_bottom() {

    difference() { 
        translate([space_depth * -1/2, -transition_extent, 0])
            rotate([90, 0, 0])
            hull() {
                translate([0, 0, 0]) {
                    rotate([0, 0, 90])
                    linear_extrude(height = kis) {
                        logo_profile();
                    }
                }
                
                translate([0, 0, joint_extent]) {
                    rotate([0, 0, 90])
                    linear_extrude(height = kis) {
                        logo_profile();
                    }
                }
            }
        outside_stencil();
        bottom_tilter(tilter_radius, logo_height);
        nut_stencil();
    }
}
//joint_bottom();


module clipon() { 
    end_cap();
    bracket_clip_on();
    transition();
    joint_bottom();
}
clipon();

