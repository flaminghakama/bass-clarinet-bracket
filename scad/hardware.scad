use <MCAD/boxes.scad>
$fa = 1;
$fs = 0.4;
$fn = 100;

// The bass clarinet hardware
hw_height = 42.5;
hw_width = 2.9;
hw_depth = 15.5;
hw_radius = 1.4;
hw_translate = hw_height/2;

hw_depth_to_plate = 13.7;
hw_plate_thickness = hw_depth - hw_depth_to_plate;
hw_plate_width = 18.0;
hw_plate_height = 41.3;

hw_ring_ID = 9.9;
hw_ring_OD = 15.0;
hw_ring_crossover = 3.6;
hw_ring_cross_OD_YZ = 2.6;
hw_ring_cross_OD_X = hw_width;

// radius from origin to center of oval
hw_ring_radius = (hw_ring_OD/2 + hw_ring_ID/2)/2;

//  Distance between adjacent rings
hw_ring_offset = hw_ring_crossover - hw_ring_cross_OD_YZ;

//  Outside radius
hw_ring_overall_radius = hw_ring_radius + hw_ring_cross_OD_YZ/2;

verticalShift = (hw_ring_overall_radius*2 - hw_ring_cross_OD_YZ) + hw_ring_offset;

module oval(space) {
    rotate([0, 180, 90])
    scale([hw_ring_cross_OD_X + space*2, hw_ring_cross_OD_YZ + space*2]) { 
        circle(r = 1/2);
    }
}

module ring(space=0) {
    rotate([0, 90, 0])
    rotate_extrude(angle=360) {
        translate([hw_ring_radius, 0])
        oval(space);
    }
}

module rings() {

    translate([0, 0, hw_ring_overall_radius])
    ring();

    translate([0, 0, hw_ring_overall_radius + verticalShift])
    ring();

    translate([0, 0, hw_ring_overall_radius + verticalShift*2])
    ring();
}

module plate(space=0) {
    translate([0, 0, hw_plate_height/2 + (hw_height - hw_plate_height)/2])
    rotate([90, 0, 0]) {
        linear_extrude(height = hw_plate_thickness + space) {
            scale([hw_plate_width + space*2, hw_plate_height + space*2]) { 
                circle(r = 1/2);
            }
        }
    }
}

module hardware() {
    plate();
    translate([0, -hw_depth/2, 0])
    rings();
}

// hardware();