include <../lib/BOSL2/std.scad>

$fa = 1;
$fs = 0.4;
$fn = 100;

//  The part of the clip on that attaches to our bracket, not part of our model
// * Clip on bottom clamp max height = 12.4
// * Clip on bottom clamp min height = 3.4
// * Clip on width = 12.3

space_depth = 20.0;
space_height_min = 2.2;
space_height_max = 4.3;
space_peak_width = 4.1;
space_peak_center = 7.5;
space_stroke_width = 1.2;
ssw = space_stroke_width/2;
space_extent = 30;
cap_extent = 4;
transition_extent = 40; 
extrude_extent = 0.01;
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

//  The part the clip-on attaches to
module bracket_clip_on() {
    translate([-space_depth/2, space_extent, 0])
    rotate([90, 0, 0])
    linear_extrude(space_extent)
        clipon_space_profile();
}
// bracket_clip_on();


filespec = "../svg/altjazzark-logo-outline.svg";
logo_aspect = 1227.8/610.6;
logo_height = 14;
logo_width = logo_height * logo_aspect;

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
        linear_extrude(height = extrude_extent) {
            clipon_space_profile();
        }
        
        translate([0, 0, transition_extent]) {
            linear_extrude(height = extrude_extent) {
                logo_profile();
            }
        }
    }
}

// transition();



module end_cap() {
    translate([0, 0])
    rotate([0, 0, 0])
    hull() {
        linear_extrude(height = extrude_extent) {
            clipon_space_profile();
        }
        
        translate([0, 0, 20]) {
            rotate([0, 0, 90])
            linear_extrude(height = extrude_extent) {
                logo_profile();
            }
        }
    }
}
end_cap();


