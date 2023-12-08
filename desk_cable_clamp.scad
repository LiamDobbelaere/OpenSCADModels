clamp_length = 70;
clamp_depth = 40;
clamp_space_height = 40;
clamp_outwards_thickness = 3;
cable_holder_radius = 5;
cable_holder_outwards_thickness = 1;
cable_holder_offset = 1;
cable_holder_length = 70;
cable_holder_count = 4;
cable_holder_attach_height_offset = 1;
cable_holder_x_offset = -22;
$fn= $preview ? 32 : 64;

module base() {
 difference() {
    color("red", 0.5)
    translate([0, clamp_outwards_thickness * 2, 0])
    cube(
        [
            clamp_length, 
            clamp_depth + clamp_outwards_thickness,
            clamp_space_height + clamp_outwards_thickness * 2
        ],
        true
    );
    color("blue", 0.5)
    translate([0, clamp_outwards_thickness * 1.5, 0])
    cube(
        [clamp_length, clamp_depth, clamp_space_height],
        true
    );
  }  
}

module cable_holder() {
    for ( i = [0 : cable_holder_count - 1] ){
        cable_holder_diameter = cable_holder_radius * 2;
        difference() {
            translate([
                i * (cable_holder_diameter + cable_holder_offset), 
                -cable_holder_outwards_thickness - 0.25, 
                0
            ])
            color("red", 0.5)
            cylinder(
                r = cable_holder_radius + cable_holder_outwards_thickness,
                h = cable_holder_length, 
                center = true
            );        
            translate([
                i * (cable_holder_diameter + cable_holder_offset), 
                0, 
                0
            ])
            color("blue", 0.5)
            cylinder(
                r = cable_holder_radius,
                h = cable_holder_length, 
                center = true
            );
        }
    }    
}

base();

rotate([90, 0, -90]) 
translate([
    cable_holder_x_offset,
    (clamp_space_height / 2 + clamp_outwards_thickness + cable_holder_radius + cable_holder_outwards_thickness) - cable_holder_attach_height_offset,
    (clamp_length - cable_holder_length) / 2
])
cable_holder();

