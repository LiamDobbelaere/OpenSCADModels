base_length = 100;
base_width = 20;
base_height = 1.5;
dove_min = 6;
dove_max = 12;
dove_length = 12;
cylinder_diameter = 3.4;
cylinder_height = 17.5;

$fn= $preview ? 32 : 64;

module base() {
    cube(
        [base_width, base_length, base_height],
        center = true
    );
}

module dovetail() {
    color([0, 1, 0])
    linear_extrude(base_height)
    polygon([
        [-dove_min/2, -dove_length/2],
        [-dove_max/2, dove_length/2],
        [dove_max/2, dove_length/2],
        [dove_min/2, -dove_length/2]
    ]);
}

module inverse_dovetail() {
    color([1, 0, 0])
    linear_extrude(base_height)
    polygon([
        [-dove_min/2, -dove_length/2],
        [-dove_min/2-(base_width+dove_max)/2, -dove_length/2],
        [-dove_min/2-(base_width+dove_max)/2, dove_length/2],
        [-dove_max/2, dove_length/2]    
    ]);
    color([1, 0, 0])
    linear_extrude(base_height)
    polygon([
        [dove_min/2, -dove_length/2],
        [dove_min/2+(base_width+dove_max)/2, -dove_length/2],
        [dove_min/2+(base_width+dove_max)/2, dove_length/2],
        [dove_max/2, dove_length/2]    
    ]);
}

module go_to_dovetail_start() {
    translate([0, -base_length/2 + dove_length/2, -base_height/2])
    children(0);
}

module go_to_dovetail_end() {
    translate([0, base_length/2 - dove_length/2, -base_height/2])
    children(0);
}

union() {
    difference() {
        base();

        go_to_dovetail_start() {
            dovetail();
        }
        go_to_dovetail_end() {
            inverse_dovetail();        
        }
    }
    
    translate([0, 0, cylinder_height/2 + base_height/2])
    cylinder(h = cylinder_height, d = cylinder_diameter, center = true);
}

