use <MCAD/boxes.scad>
include <../lib/BOSL2/std.scad>

include <clipon.scad>
include <hardware.scad>
//filespec = "../svg/altjazzark-logo-outline.svg";

// Quick Release
// https://www.thingiverse.com/thing:2458429

// The bass clarinet
inst_diameter = 41.0;
inst_radius = inst_diameter/2;
inst_height = 240;
key_distance_max = 78.0 - inst_radius;
key_distance_min = 58.9 - inst_radius;
key_angle = 35;

//  The bracket 
logo_aspect = 1227.8/610.6;
logo_height = 12;
logo_width = logo_height * logo_aspect;

wheel_radius_scale = 3;
wheel_radius = inst_radius * wheel_radius_scale;
forward_tilt = 36;
side_tilt = 0;
arc = 360;

cover_thickness = 3;
cover_width = 12;
cover_below_extent = hw_ring_cross_OD_YZ;
cover_height = hw_height + cover_thickness*2 + cover_below_extent;
cover_depth = hw_depth + cover_thickness;
cover_radius = 2.5;
cover_translate = cover_height/2 - cover_below_extent;

handle_sweep_angle  = -115;
handle_twist  = -90;
handle_height = inst_diameter * 2;


module instrument() {
    translate([0, 0, -inst_height/2])
        linear_extrude(height=inst_height)
            circle(inst_diameter/2);
}
module keys() { 
    translate([0, 0, -inst_height/4])
    rotate([0, 0, 135])
    pie_slice(ang = key_angle, r = key_distance_min, h = inst_height/2);

    translate([0, 0, 0])
    rotate([0, 0, 135])
    pie_slice(ang = key_angle, r = key_distance_max, h = inst_height/2);
}
color("brown") { 
    instrument();
}   

//  The hardware
color("grey") { 
    //keys();
    //translate([0, inst_radius*-1, 0])
    //hardware();
}   


module bracket_inside_space() {

    space = 0.2;

    // Plate
    translate([0, inst_radius*-1, 0])
    plate(space);

    //  top ring
    translate([0, inst_radius*-1 -hw_depth/2, hw_ring_overall_radius + verticalShift*2])
    ring(space);

    //  cylinder to fill up inside of top ring
    cyl_fill_radius = hw_ring_ID/2 + (hw_ring_OD - hw_ring_ID)/4;
    top_ring_center_height = hw_ring_overall_radius + verticalShift*2;
    translate([-hw_width/2 - space, inst_radius*-1 -hw_depth/2, hw_ring_overall_radius + verticalShift*2])
    rotate([0, 90, 0])
    cylinder(r = cyl_fill_radius, h = hw_width + space*2);

    //  profile of cross section of ring filled in
    translate([0, 0, -cover_below_extent])
    linear_extrude(height=hw_ring_overall_radius + cover_below_extent + verticalShift*2)
        translate([0, inst_radius*-1 -hw_depth/2, -cover_below_extent])
        hull() {
            translate([0, -cyl_fill_radius, 0]) {
                rotate([0, 0, 90])
                oval(space);
            }
            translate([0, cyl_fill_radius, 0]) {
                rotate([0, 0, 90])
                oval(space);
            }
        }      

    //  space for dowel through bottom ring
    bottom_ring_center_height = hw_ring_overall_radius;
    bottom_ring_cutout_extent = cover_width + kiss;
    translate([-bottom_ring_cutout_extent/2, inst_radius*-1 -hw_depth/2, hw_ring_overall_radius])
    rotate([0, 90, 0])
    cylinder(r = hw_ring_ID/2 + space , h = bottom_ring_cutout_extent);
}

color("white") { 
    //bracket_inside_space();
}   

module butterfly_net_sweep(stretch=1) {
    slices = 256;
    
    for (i = [0 : slices - 1]) {
        p1 = i / slices;
        p2 = (i + 1) / slices;

        //  start steep and end shallow
        scaling = 1 - ((1 - p1)*(1 - p1)*(1 - p1));
        z_offset = stretch * scaling;
    
        hull() {
            // STEP 1: Current Layer
            rotate([0, 0, p1 * handle_sweep_angle])
            translate([wheel_radius, 0, -z_offset])
            rotate([0, p1 * handle_twist, 0])
            rotate([90, 0, 0]) 
            linear_extrude(height = 0.01, center = true) {
                rotate([0, 0, 90])
                resize([logo_width, logo_height])
                import(filespec, center = true);
            }

            // STEP 2: Next Layer (Bridge to capture continuous volume)
            rotate([0, 0, p2 * handle_sweep_angle])
            translate([wheel_radius, 0, -z_offset])
            rotate([0, p2 * handle_twist, 0])
            rotate([90, 0, 0]) 
            linear_extrude(height = 0.01, center = true) {
                rotate([0, 0, 90])
                resize([logo_width, logo_height])
                import(filespec, center = true);
            }
        }
    }
}
//butterfly_net_sweep(handle_height);

module top_tilter_teeth(radius=tilter_radius, height=logo_height) {
    translate([space_depth * -1/2, -(radius + transition_extent), 0])
    union() {
        for (i = [0 : 360/teeth : 360]) {
            rotate([0, 0, i])
            translate([radius * teeth_placement, 0, (height/2)-1])
            cylinder(r1=tooth_radius, r2=tooth_tolerance, h=tooth_depth);
        }
    }
}
//top_tilter_teeth();

module top_tilter_bolt_hole(radius=tilter_radius, height=logo_height) {
    translate([space_depth * -1/2, -(radius + transition_extent), 0])
    cylinder(r=(bolt_diameter/2)+tooth_tolerance, h=height*2, center=true);
}
//top_tilter_bolt_hole();

module bolt_head_stencil() { 
    translate([-space_depth/2, -(transition_extent + tilter_radius), logo_height * -1/2])
        linear_extrude(height = bolt_head_height + ssw) {
            circle(d = bolt_head_OD);
        }
}
//bolt_head_stencil();


module joint_top() {

    difference() { 
        union()  { 
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
            top_tilter_teeth();
        }
        outside_stencil();
        top_tilter_bolt_hole();
        bolt_head_stencil();
    }
}
//joint_top();

module my_top_joint() {
    translate([-66.9, 14.5, logo_height - (hw_ring_OD*2.4 + 22)])
    rotate([0, 180, 155])
    joint_top();
}
//my_top_joint();


module combined_bracket() {     
    yTrans = wheel_radius - (logo_height/2 + inst_radius + hw_plate_thickness + (cover_depth - logo_height)/2);
    translate([-hw_width, yTrans, hw_ring_OD*2.4])
        rotate([0, 0, -90])
        butterfly_net_sweep(handle_height);
        
    difference() {
        translate([0, -(inst_radius + cover_depth/2), cover_translate])
            roundedBox(size=[cover_width, cover_depth, cover_height],radius=cover_radius,sidesonly=false);
        bracket_inside_space();
    }
}
color("yellow") { 
    combined_bracket();
    my_top_joint();


    translate([-40, 118, -60])
    rotate([0, 0, -15])
    clipon();
}

