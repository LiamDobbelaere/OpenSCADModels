/* === Piece selection === */
piece = "stacker";

/* === Basic Dimensions === */
base_thickness = 10;
base_radius = 34;
base_connector_thickness = 2.5;
base_connector_radius = 16;
path_center_offset = 1.5;
path_radius = 6.75;
port_bottom_offset = 2.5;
port_length = 6;
stacker_height = 10;

/* === Derivatives === */
base_apothem = sqrt(3) / 2 * base_radius;

// inter-piece distance, vertical means flat side to flat side
vertical_ipd = base_apothem * 2;

large_bend_circle_radius = vertical_ipd - .8 - path_radius;
small_bend_circle_radius = 24 + .6 - path_radius;

tower_radius = 26;
tower_height = 70;

/* === Rendering === */
torus_detail = $preview ? 16 : 64;
rotate_extrude_detail = $preview ? 32 : 128;
csg_sub_correction = 0.01;

/* === Colors (OpenSCAD only) === */
primary_color = "white";
secondary_color = "#79B51C";
tertiary_color = "gray";
quaternary_color = "#333";

module base() {
    color(primary_color)
    cylinder(r=base_radius, h=base_thickness, $fn=6);
    connector();
}

module connector() {
    color(primary_color)
    translate([0, 0, -base_connector_thickness])
    cylinder(r=base_connector_radius, h=base_connector_thickness, $fn=6);    
}

module path_bend_top() {
    color(secondary_color)
    translate([0, vertical_ipd, base_thickness + path_center_offset])
    rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
    translate([large_bend_circle_radius, 0, 0])
    circle(r = path_radius, $fn = torus_detail);
}

module path_bend_bottom_right() {
    color(secondary_color)
    translate([vertical_ipd * 0.29, -vertical_ipd * 0.5, base_thickness + path_center_offset])
    rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
    translate([small_bend_circle_radius, 0, 0])
    circle(r = path_radius, $fn = torus_detail);
}

module path_straight(rot = 0) {
    translate([0, 0, base_thickness + path_center_offset])
    rotate([0, 90, rot]) {
        linear_extrude(base_radius * 2, center = true, convexity = 10)
        circle(r = path_radius, $fn = torus_detail);        
    }
}

module path_lateral_to_diagonal(flip_x = 0) {
    difference() {
        color(secondary_color)
        mirror([0, 1, 0])
        mirror([flip_x, 0, 0])
        translate([base_radius, base_radius * -0.5 - 2, base_thickness + path_center_offset])
        rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
        translate([base_radius, 0, 0])
        circle(r = path_radius, $fn = torus_detail);
        util_lower_cutoff(0.65);
    }
}

module port_lateral_sub(y_dir = 1, width = path_radius * 2) {
    translate([
        0,
        y_dir * base_apothem,
        (base_thickness + port_bottom_offset) * 0.5 + csg_sub_correction
    ])
    color(primary_color)
    cube([
        width, 
        port_length, 
        base_thickness - port_bottom_offset
    ], true);
}

module port_sub(x_dir = 1, y_dir = 1, width = path_radius * 2) {
    c = base_radius;
    a = c * sin(60);
    //b = base_radius / 2;
    //a = sqrt(pow(c, 2) - pow(b, 2));
    port_x = (a - port_length / 2) * cos(30) + csg_sub_correction;
    port_y = (a - port_length / 2) * sin(30) + csg_sub_correction;
    
    translate([
        x_dir * port_x,
        y_dir * port_y,
        (base_thickness + port_bottom_offset) * 0.5 + csg_sub_correction
    ])
    rotate([0, 0, 60 * -x_dir * y_dir])
    color(primary_color)
    cube([
        width, 
        port_length, 
        base_thickness - port_bottom_offset
    ], true);
}

module util_lower_cutoff(cutoff_factor = 0) {
    cutoff = base_apothem * cutoff_factor;
    
    translate([0, base_apothem * 0.5 + cutoff * 0.5, base_thickness * 0.5])
    cube([base_radius * 2, base_apothem - cutoff, base_thickness], true);
}

module port(x_dir = 1, y_dir = 1) {
    difference() {
        port_sub(x_dir, y_dir, path_radius  * 2);
        port_sub(x_dir, y_dir, path_radius);
    }
}

module port_lateral(y_dir = 1) {
    difference() {
        port_lateral_sub(y_dir, path_radius * 2);
        port_lateral_sub(y_dir, path_radius);
    }
}

module piece_curve() {
    difference() {    
        base();
        port(1, 1);
        port(-1, 1);
        port(1, -1);
        port_lateral(-1);
        path_bend_top();
        path_bend_bottom_right();
    }
}

module tower_base() {
    difference() {
        color(tertiary_color)
        cylinder(r=tower_radius, h=tower_height, $fn=6);
        translate([0, 0, tower_height - base_connector_thickness + 0.1])
        color(secondary_color)
        cylinder(r=base_connector_radius, h=base_connector_thickness, $fn=6);        
    }
    connector();
}

module piece_tower() {
    tower_base();
}

module stacker_sub(height, col) {
    difference () {
        color(col)
        cylinder(r1=tower_radius + 1, r2=tower_radius, h=height, $fn=6);
        translate([0, 0, height - base_connector_thickness + 0.1])
        color(col)
        cylinder(r=base_connector_radius, h=base_connector_thickness, $fn=6);                
    }
    connector();
}

module piece_stacker() {
    stacker_sub(stacker_height, tertiary_color);
}

module piece_stacker_half() {
    stacker_sub(stacker_height / 2, quaternary_color);
}

module piece_threeway() {
    difference() {
        base();
        port_lateral(-1);
        port_lateral(1);
        port(-1,-1);
        port(1,-1);
        path_lateral_to_diagonal(0);
        path_lateral_to_diagonal(1);
        path_straight(90);
    }
}

/* === Piece generation === */
if (piece == "curve") piece_curve();
if (piece == "tower") piece_tower();
if (piece == "stacker_half") piece_stacker_half();
if (piece == "stacker") piece_stacker();
if (piece == "threeway") piece_threeway();
