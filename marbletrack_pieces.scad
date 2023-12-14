/* === Basic Dimensions === */
base_thickness = 10;
base_radius = 34;
base_connector_thickness = 2.5;
base_connector_radius = 16;
path_center_offset = 1.5;
path_radius = 6.75;
port_bottom_offset = 2.5;
port_length = 6;

/* === Derivatives === */
base_apothem = sqrt(3) / 2 * base_radius;

// inter-piece distance, vertical means flat side to flat side
vertical_ipd = base_apothem * 2;

large_bend_circle_radius = vertical_ipd - .9 - path_radius;
small_bend_circle_radius = 24 - path_radius;

tower_radius = 26;
tower_height = 70;
tower_inner_radius = 16;
tower_inner_height = 3;

/* === Rendering === */
torus_detail = 32;
rotate_extrude_detail = 64;
draft_render_correction = $preview ? 0.01 : 0; // disable this if final rendering


/* === Colors (OpenSCAD only) === */
primary_color = "white";
secondary_color = "#79B51C";
tertiary_color = "gray";

module base() {
    color(primary_color, 0.5)
    cylinder(r=base_radius, h=base_thickness, $fn=6);
    color(primary_color, 0.5)
    translate([0, 0, -base_connector_thickness])
    cylinder(r=base_connector_radius, h=base_connector_thickness, $fn=6);    
}

module bend_top() {
    color(secondary_color)
    translate([0, vertical_ipd, base_thickness + path_center_offset])
    rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
    translate([large_bend_circle_radius, 0, 0])
    circle(r = path_radius, $fn = torus_detail);
}

module bend_bottom_right() {
    color(secondary_color)
    translate([vertical_ipd * 0.29, -vertical_ipd * 0.5, base_thickness + path_center_offset])
    rotate_extrude(convexity = 10, $fn = rotate_extrude_detail)
    translate([small_bend_circle_radius, 0, 0])
    circle(r = path_radius, $fn = torus_detail);
}

module port(x_dir = 1, y_dir = 1) {
    c = base_radius;
    b = base_radius / 2;
    a = sqrt(pow(c, 2) - pow(b, 2));
    port_x = (a - port_length / 2) * cos(30) + draft_render_correction;
    port_y = (a - port_length / 2) * sin(30) + draft_render_correction;
    
    translate([
        x_dir * port_x,
        y_dir * port_y,
        (base_thickness + port_bottom_offset) * 0.5 + draft_render_correction
    ])
    rotate([0, 0, 60 * -x_dir])
    cube([
        path_radius * 2, 
        port_length, 
        base_thickness - port_bottom_offset
    ], true);
}

module piece_lsb() {
    difference() {    
        base();
        port();
        port(-1);
        bend_top();
        //bend_bottom_right();
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
