// basic dimensions
base_thickness = 10;
base_radius = 34;
base_connector_thickness = 2.5;
base_connector_radius = 16;
path_center_offset = 1.5;
path_radius = 6.75;

ipd = 60;
diagonal_ipd = 35;

large_bend_circle_radius = ipd - path_radius;
small_bend_circle_radius = 24 - path_radius;

tower_radius = 26;
tower_height = 70;
tower_inner_radius = 16;
tower_inner_height = 3;

// rendering settings
torus_detail = 32;
rotate_extrude_detail = 64;

// color settings (OpenSCAD only)
primary_color = "white";
secondary_color = "#79B51C";
tertiary_color = "gray";

module base() {
    color(primary_color)
    cylinder(r=base_radius, h=base_thickness, $fn=6);
    color(primary_color)
    translate([0, 0, -base_connector_thickness])
    cylinder(r=base_connector_radius, h=base_connector_thickness, $fn=6);    
}

module bend_top() {
    color(secondary_color)
    translate([0, ipd, base_thickness + path_center_offset])
    rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
    translate([large_bend_circle_radius, 0, 0])
    circle(r = path_radius, $fn = torus_detail);
}

module bend_bottom_right() {
    color(secondary_color)
    translate([ipd * 0.29, -ipd * 0.5, base_thickness + path_center_offset])
    rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
    translate([small_bend_circle_radius, 0, 0])
    circle(r = path_radius, $fn = torus_detail);
}

module piece_lsb() {
    difference() {    
        base();
        bend_top();
        bend_bottom_right();
    }    
}

module tower_base() {
    difference() {
        color(tertiary_color)
        cylinder(r=tower_radius, h=tower_height, $fn=6);
        translate([0, 0, tower_height - tower_inner_height + 0.1])
        color(secondary_color)
        cylinder(r=tower_inner_radius, h=tower_inner_height, $fn=6);        
    }
}

module piece_tower() {
    tower_base();
}

piece_lsb();

//piece_tower();
