cable_holder_length = 20;
cable_holder_height = 5;
cable_holder_wall_thickness = 0.25;
cable_large_thickness = 7;
cable_small_thickness = 3;
cable_large_count = 2;
cable_small_count = 4;
cable_thickness_slack = 0.1;

module cable_holder(thickness) {
    thickness = thickness + cable_thickness_slack * 2;
    wall_thickness = cable_holder_wall_thickness * 2;

    
    difference() {       
        color("red", 0.5)
        translate([0, 0, -wall_thickness * 0.25])
        cube([
            thickness + wall_thickness,
            cable_holder_length + wall_thickness, 
            cable_holder_height + wall_thickness * 0.5
        ],
        true);
        color("blue", 0.5)
        cube(
            [thickness, cable_holder_length + wall_thickness, cable_holder_height], 
            true
        );
   }
}

module cables_subunit(thickness, count) {
    for (n = [0 : count - 1]) {
        translate([
            n * 
            (thickness + cable_thickness_slack * 2 + cable_holder_wall_thickness),
            0,
            0,
        ])
        cable_holder(thickness);
    }    
}

module cable_holder_unit() {
    cables_subunit(cable_large_thickness, cable_large_count);
    translate([cable_large_count * (cable_large_thickness - cable_thickness_slack * 2 - cable_holder_wall_thickness), 0, 0]) cables_subunit(cable_small_thickness, cable_small_count);
}


cable_holder_unit();
color("green", 0.5)
cube([cable_large_thickness * cable_large_count, cable_holder_length + cable_holder_wall_thickness * 2, cable_holder_height]);