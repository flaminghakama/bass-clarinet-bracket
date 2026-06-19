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
space_stroke_width = 1;
ssw = space_stroke_width/2;
//  The origin is located at the bottom left of the space profile
space_profile = [
    [ssw, ssw],
    [space_depth - ssw, ssw],
    [space_depth - ssw, space_height_min - ssw],
    [space_peak_center + space_peak_width/2 - ssw, space_height_min - ssw],
    [space_peak_center, space_height_max - ssw],
    [space_peak_center + ssw - space_peak_width/2, space_height_min - ssw],
    [ssw, space_height_min - ssw]
];

offset(r = 0.5) { // 1mm expansion matches a stroke width of 2
    polygon(space_profile);
}


