module pad_xl() {
    cube([22, 19, 1]);
}

module pad_l() {
    cube([19, 10, 1]);
}

module pad_m() {
    cube([14, 8, 1]);
}

module pad_s() {
    cube([9, 9, 1]);
}

module circle_l() {
    cylinder(1, d = 17);
}

module circle_s() {
    cylinder(1, d = 8);
}

module grill_slot() {
    cube([7, 1, 1]);
}

// 132 wide, 24 high
module knobs(width, depth, height) {
     translate([depth / 2, 0, 0]) hull() {
        translate([width - depth, 0, 0]) cylinder(height, d = depth);
        cylinder(height, d = depth);
    }
}

// 12mm from top/bottom
module screw() {
    circle(1, d = 3);
}

function radius_from_chord_height(chord, height) =
    (height / 2) + ((chord * chord) / (height * 8));

// center = bool, rotate
module circle_segment(chord, height, angle = 0) {
    radius = radius_from_chord_height(chord, height);
    diameter = radius * 2;
    rotate([0, 0, angle]) translate([height - radius, 0, 0]) difference() {
        translate([0, 0, 0]) cylinder(1, r = radius, center = true);
        translate([-height, 0, 0]) cube([diameter, diameter, 1], center = true);
    }
}

// height = 255;
// tall = 15;

// outer circles are smaller than the total width
module screen() {
    width_outer = 115;
    width_inner = 93;
    delta_width = 11;
    height_inner = 55;
    height_outer = 64;
    delta_height = (height_outer - height_inner) / 2;
    edge_distance = 30;
    union(){
        translate([width_inner / 2, 0, 0]) circle_segment(55, 11);
        translate([-width_inner / 2, 0, 0]) circle_segment(55, 11, 180);
        translate([0, height_inner / 2, 0]) circle_segment(32, 5, 90);
        translate([0, -height_inner / 2, 0]) circle_segment(32, 5, 270);
        cube([width_inner, height_inner, 1], center = true);
    }    
}

screen();