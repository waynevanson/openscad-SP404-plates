
pad_large_width = 22;
pad_large_depth = 19;
module pad_l() {
    square([pad_large_width, pad_large_depth], center = true);
}

pad_medium_width = 14;
pad_medium_depth = 10;
module pad_m() {
    square([pad_medium_width, pad_medium_depth], center = true);
}


pad_small_width = 14;
pad_small_depth = 8;
module pad_s() {
    square([pad_small_width, pad_small_depth], center = true);
}

pad_extra_small_width = 9;
pad_extra_small_depth = 9;
module pad_xs() {
    square([pad_extra_small_width, pad_extra_small_depth], center = true);
}

circle_tempo_diameter = 17;
module circle_tempo() {
    circle(d = circle_tempo_diameter);
}

module circle_s() {
    circle(d = 8);
}

module grill_slot() {
    circle([7, 1]);
}

// 132 wide, 24 high
module circle_stretched(width, depth) {
     translate([(depth - width) / 2, 0, 0]) hull() {
        translate([width - depth, 0, 0]) circle(d = depth);
        circle(d = depth);
    }
}

knobs_depth = 24;
module knobs() {
    circle_stretched(132, knobs_depth);
}

// 12mm from top/bottom
screw_diameter = 3;
module screw() {
    circle(1, d = screw_diameter);
}

function radius_from_chord_height(chord, height) =
    (height / 2) + ((chord * chord) / (height * 8));

module circle_segment(chord, height, angle = 0) {
    radius = radius_from_chord_height(chord, height);
    diameter = radius * 2;
    rotate([0, 0, angle]) translate([height - radius, 0, 0]) difference() {
        translate([0, 0, 0]) circle(r = radius);
        translate([-height, 0, 0]) square([diameter, diameter], center = true);
    }
}
 
screen_outer_width = 115;
screen_outer_depth = 64;

screen_inner_width = 93;
screen_inner_depth = 55;

module screen() {
    width_delta = (screen_outer_width - screen_inner_width) / 2;
    height_delta = (screen_outer_depth - screen_inner_depth) / 2;
    
    union() {
        translate([screen_inner_width / 2, 0, 0])
            circle_segment(screen_inner_depth, width_delta);
        
        translate([-screen_inner_width / 2, 0, 0])
            circle_segment(screen_inner_depth, width_delta, 180);
        
        translate([0, screen_inner_depth / 2, 0])
            circle_segment(32, height_delta, 90);
        
        translate([0, -screen_inner_depth / 2, 0])
            circle_segment(32, height_delta, 270);
        
        square([screen_inner_width, screen_inner_depth], center = true);
    }    
}

plate_depth = 255;
module plate() {
    square([150, plate_depth], center = true);
}


pattern_sequencer_width =
    3 * pad_medium_width + 14 + 3;
module pattern_sequencer() {
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_m();
   
    position_1 = position_0 + pad_medium_width + 14;
    translate([position_1, 0, 0])
        pad_m();
   
    position_2 = position_1 + pad_medium_width + 3;
    translate([position_2, 0, 0])
        pad_m();
}

sample_edit_width = 
    2 * pad_medium_width + 3;
module sample_edit() {
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_m();
   
    position_1 = position_0 + pad_medium_width + 3;
    translate([position_1, 0, 0])
        pad_m();
}

row_03_width =
    pattern_sequencer_width + 7 +
    sample_edit_width + 13 +
    circle_tempo_diameter;
row_03_depth_excluding_tempo = pad_medium_depth;

module row_03() {
    translate([(pad_medium_width / 2  - row_03_width) / 2, 0, 0]) {
        position_0 = 0;
        translate([position_0, 0, 0])
            pattern_sequencer();
        
        position_1 = position_0 + pattern_sequencer_width + 7;
        translate([position_1, 0, 0])
            sample_edit();
        
        position_2 = position_1 + sample_edit_width + 13;
        translate([position_2, 0, 0])
            circle_tempo();        
    }
};

sampling_width =
    2 * (pad_medium_width + 3.5) + pad_small_width;
module sampling() {
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_m();
   
    position_1 = position_0 + pad_medium_width + 3;
    translate([position_1, 0, 0])
        pad_m();
    
    position_2 = position_1 + pad_medium_width + 3;
    translate([position_2, 0, 0])
        pad_s();
}

sample_mode_width =
    2 * pad_extra_small_width +
    3 * pad_medium_width +
    4 * 3;
module sample_mode() {
    pad_xs();
    
    position_1 = pad_extra_small_width + 3;
    translate([position_1, 0, 0])
        pad_xs();
    
    position_2 = position_1 + pad_extra_small_width + 3 + 3;
    translate([position_2, 0, 0])
        pad_m();
   
    position_3 = position_2 + pad_medium_width + 3;
    translate([position_3, 0, 0])
        pad_m();
    
    position_4 = position_3 + pad_medium_width + 3;
    translate([position_4, 0, 0])
        pad_m();
}

row_04_width =
    sampling_width + 3 + sample_mode_width ;
row_04_depth =
    pad_medium_depth;

module row_04() {
    translate([(pad_medium_width / 2 - row_04_width) / 2, 0, 0]) {
        sampling();
        translate([sampling_width + 3, 0, 0])
            sample_mode();
    }
}

module SP404SX() {
    top_from_origin = (-255 / 2);
    linear_extrude(1, center = true)
    difference() {
        plate();
        
        top_01 = top_from_origin + 23;
        translate([0, top_01, 0])
            knobs();
        
        top_02 = top_01  + (screen_outer_depth / 2) + (knobs_depth / 2) + 4;
        translate([0, top_02, 0])
            screen();
        
        top_03 = top_02 + (row_03_depth_excluding_tempo / 2) + (screen_outer_depth / 2) + 4;
        translate([0, top_03, 0])
            row_03();
        
        top_04 = top_03 + (row_04_depth / 2) + (row_03_depth_excluding_tempo / 2) + 4;
        translate([0, top_04, 0]);
            row_04();
    }   
}

SP404SX();