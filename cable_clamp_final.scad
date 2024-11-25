wire_thickness_a = 5.06;
wire_thickness_b = 4.06;
wire_thickness_c = 3.06;

wire_length = 10;
wire_height = max(wire_thickness_a, wire_thickness_b, wire_thickness_c) * 1.25;

wall_thickness = 1.25;

wire_count_a = 3;
wire_count_b = 2;
wire_count_c = 2;

lid_gripper_length = 2.5;

b_xoffset = get_offset(wire_thickness_a, wire_count_a, wire_thickness_b);
c_xoffset = b_xoffset + get_offset(wire_thickness_b, wire_count_b, wire_thickness_c);

box_total_width = c_xoffset + get_offset(wire_thickness_c, wire_count_c, 0) - wall_thickness + wire_thickness_a / 2 + wall_thickness * 2;
lid_total_width = box_total_width - 0.06;
box_total_height = wire_height + wall_thickness;

module wire_holder(col, count, thickness, wire_offset = 0) {
    for (i = [0 : count - 1]) {
        color(col, 0.5)
        translate([wire_offset + (thickness + wall_thickness) * i, 0, 0])
        cube([thickness, wire_length, wire_height], center = true);
    }
}

function get_offset(previous_thickness, previous_count, next_thickness) = (
previous_thickness * 0.5 + previous_thickness * (previous_count - 1) + (previous_count * wall_thickness) + next_thickness * 0.5
);

module wire_holders() {
    wire_holder("red", wire_count_a, wire_thickness_a);
    wire_holder("green", wire_count_b, wire_thickness_b, b_xoffset);
    wire_holder("blue", wire_count_c, wire_thickness_c, c_xoffset);    
}

module surrounding_box(total_width = box_total_width) {
    color("white", 0.5)
    translate([-wire_thickness_a / 2 - wall_thickness, -wire_length / 2, -wire_height / 2 - wall_thickness])
    cube([total_width, wire_length, box_total_height]);
}

module lid() {
    color("blue", 0.5)
    translate([-wire_thickness_a / 2 - wall_thickness * 2, -wire_length / 2, -wire_height / 2 - wall_thickness])
    cube([lid_total_width + wall_thickness * 2, wire_length, box_total_height + wall_thickness]);
}

module lid_grippers() {
    color("purple", 0.5)
    translate([-wire_thickness_a / 2 - wall_thickness * 2, -wire_length / 2, -wire_height / 2 - wall_thickness * 2])
    cube([lid_gripper_length + wall_thickness, wire_length, wall_thickness]);
    
    color("purple", 0.5)
    translate([lid_total_width - lid_gripper_length + wall_thickness -wire_thickness_a / 2 - wall_thickness * 2, -wire_length / 2, -wire_height / 2 - wall_thickness * 2])
    cube([lid_gripper_length + wall_thickness, wire_length, wall_thickness]);
}

difference() {
    surrounding_box();
    wire_holders();  
}

translate([box_total_width - wire_thickness_a - wall_thickness * 2, 0, box_total_height + wall_thickness * 2])
rotate([0, 180, 0])
union() {
    difference() {
        lid();
        surrounding_box(lid_total_width);
    }
    lid_grippers();
}
