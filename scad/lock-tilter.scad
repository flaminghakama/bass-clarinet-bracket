// --- Parametric Lock Tilter ---

/* [Tilter Settings] */
// Total radius of the tilting disk
disk_r = 30;          
// Thickness of the disk
disk_h = 10;          
// Spacing/Gap between the two halves (in mm)
tolerance = 0.4;      

/* [Locking Mechanism] */
// Number of teeth for locking positions (e.g., 24 teeth = 15-degree steps)
teeth = 24;           

/* [Hardware] */
// Center screw/bolt diameter
bolt_d = 5;           

$fn = 100; // Smoothness

// --- Top Half (Tilter) ---
module top_tilter() {
    difference() {
        union() {
            // Main Disk
            cylinder(r=disk_r, h=disk_h, center=true);
            
            // Locking Teeth (Male side)
            for (i = [0 : 360/teeth : 360]) {
                rotate([0, 0, i])
                translate([disk_r * 0.6, 0, disk_h/2])
                cylinder(r1=2, r2=0, h=3);
            }
        }
        // Center Bolt Hole
        cylinder(r=(bolt_d/2)+tolerance, h=disk_h*2, center=true);
    }
}

// --- Bottom Half (Base/Receiver) ---
module bottom_tilter() {
    difference() {
        union() {
            // Main Disk
            cylinder(r=disk_r, h=disk_h, center=true);
            
            // Raised guide rim for better alignment
            translate([0,0,-disk_h/2])
            cylinder(r=disk_r + 2, h=disk_h/2);
        }
        // Center Bolt Hole
        cylinder(r=(bolt_d/2)+tolerance, h=disk_h*2, center=true);
        
        // Negative Locking Teeth (Female side)
        for (i = [0 : 360/teeth : 360]) {
            rotate([0, 0, i])
            translate([disk_r * 0.6, 0, (disk_h/2)-1])
            cylinder(r1=2 + tolerance, r2=tolerance, h=3 + tolerance);
        }
    }
}

// --- Render View ---
// Move parts apart so you can see the mating faces
translate([disk_r * 2.5, 0, 0]) top_tilter();
bottom_tilter();