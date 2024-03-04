module square_left_centre(xyz) {
    translate([xyz.x / 2, 0 , 0]) square(xyz, center = true);
}

module square_top_centre(xyz) {
    translate([0, xyz.y / 2 , 0]) square(xyz, center = true);
}

pad_large_width = 22;
pad_large_depth = 20;
module pad_l() {
    square_left_centre([pad_large_width, pad_large_depth]);
}

pad_medium_width = 15;
pad_medium_depth = 10;
module pad_m() {
    square_left_centre([pad_medium_width, pad_medium_depth]);
}


pad_small_width = 15;
pad_small_depth = 8;
module pad_s() {
    square_left_centre([pad_small_width, pad_small_depth]);
}

pad_extra_small_width = 10;
pad_extra_small_depth = 10;
module pad_xs() {
    square_left_centre([pad_extra_small_width, pad_extra_small_depth]);
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
    square([160, plate_depth], center = true);
}


pattern_sequencer_width =
   pad_medium_width + 15 +
   pad_medium_width + 4 +
   pad_medium_width;
module pattern_sequencer() {
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_m();
   
    position_1 = position_0 + pad_medium_width + 15;
    translate([position_1, 0, 0])
        pad_m();
   
    position_2 = position_1 + pad_medium_width + 4;
    translate([position_2, 0, 0])
        pad_m();
}

sample_edit_width = 
    pad_medium_width + 4 +
    pad_medium_width;
module sample_edit() {
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_m();
   
    position_1 = position_0 + pad_medium_width + 4;
    translate([position_1, 0, 0])
        pad_m();
}

row_03_width =
    pattern_sequencer_width + 8 +
    sample_edit_width + 13 +
    circle_tempo_diameter;
row_03_depth_excluding_tempo = pad_medium_depth;

module row_03() {
    // button on right goes extra wide
    translate([-row_03_width / 2, 0, 0]) {
        position_1 = 0;
        translate([position_1, 0, 0])
            pattern_sequencer();
        
        position_2 = position_1 + pattern_sequencer_width + 8;
        translate([position_2, 0, 0])
            sample_edit();
        
        position_3 = position_2 + sample_edit_width + 13;
        translate([position_3, 0, 0])
            circle_tempo();        
    }
};

sampling_width =
    pad_medium_width + 4 +
    pad_medium_width + 4 +
    pad_small_width;
    
module sampling() {
    position_1 = 0;
    translate([position_1, 0, 0])
        pad_m();
   
    position_2 = position_1 + pad_medium_width + 4;
    translate([position_2, 0, 0])
        pad_m();
    
    position_3 = position_2 + pad_medium_width + 4;
    translate([position_3, 0, 0])
        pad_s();
}

sample_mode_width =
    pad_extra_small_width + 4 +
    pad_extra_small_width + 4 +
    pad_medium_width + 3 +
    pad_medium_width + 4 +
    pad_medium_width;
module sample_mode() {
    position_1 = 0;
    translate([position_1, 0, 0])
        pad_xs();
    
    position_2 = position_1 + pad_extra_small_width + 4;
    translate([position_2, 0, 0])
        pad_xs();
    
    position_3 = position_2 + pad_extra_small_width  + 4;
    translate([position_3, 0, 0])
        pad_m();
   
    position_4 = position_3 + pad_medium_width + 3;
    translate([position_4, 0, 0])
        pad_m();
    
    position_5 = position_4 + pad_medium_width + 4;
    translate([position_5, 0, 0])
        pad_m();
}

row_4_width =
    sampling_width + 4 + sample_mode_width ;
row_4_depth =
    pad_medium_depth;
module row_4() {
    translate([-row_4_width / 2, 0, 0]) {
        sampling();
        translate([sampling_width + 4, 0, 0])
            sample_mode();
    }
}

control_width = 
    pad_medium_width + 4 +
    pad_medium_width + 4 +
    pad_medium_width;
module control() {
    // Offset from the center of the pad so origin is left justified, center aligned      
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_s();
    
    position_1 = position_0 + pad_small_width + 4;
    translate([position_1, 0, 0])
        pad_s();
    
    position_2 = position_1 + pad_medium_width + 4;
    translate([position_2, 0, 0])
        pad_m();    
}

bank_width = 
    pad_extra_small_width + 4 +
    pad_extra_small_width + 4 +
    pad_extra_small_width + 4 +
    pad_extra_small_width + 4 +
    pad_extra_small_width + 4 +
    pad_extra_small_width;
module bank() {
    // Offset from the center of the pad so origin is left justified, center aligned    
    position_0 = 0;
    translate([position_0, 0, 0])
        pad_xs();
    
    position_1 = position_0 + pad_extra_small_width + 4;
    translate([position_1, 0, 0])
        pad_xs();
    
    position_2 = position_1 + pad_extra_small_width + 4;
    translate([position_2, 0, 0])
        pad_xs();

    position_3 = position_2 + pad_extra_small_width + 4;
    translate([position_3, 0, 0])
        pad_xs();
    
    position_4 = position_3 + pad_extra_small_width + 4;
    translate([position_4, 0, 0])
        pad_xs();
    
    position_5 = position_4 + pad_extra_small_width + 4;
    translate([position_5, 0, 0])
        pad_xs();
}


row_5_width = control_width + 4 + bank_width;
row_5_depth = pad_extra_small_depth;
module row_5() {
    translate([-row_5_width / 2, 0, 0]) {
        control();
        translate([control_width + 4, 0, 0])
            bank();
    }
}

row_pads_width = 
    pad_large_width + 5 +
    pad_large_width + 5 +
    pad_large_width + 5 +
    pad_large_width + 5 +
    pad_large_width;

row_pads_depth = pad_large_depth;
module row_pads() {
    translate([-row_pads_width / 2, 0, 0]) {
        position_1 = pad_large_width / 2;
        translate([position_1, 0, 0])
            pad_l();
        
        position_2 = position_1 + pad_large_width + 5;
        translate([position_2, 0, 0])
            pad_l();
        
        position_3 = position_2 + pad_large_width + 5;
        translate([position_3, 0, 0])
            pad_l();

        position_4 = position_3 + pad_large_width + 5;
        translate([position_4, 0, 0])
            pad_l();

        position_5 = position_4 + pad_large_width + 5;
        translate([position_5, 0, 0])
            pad_l();
    }
}

module SP404SX() {
    top_from_origin = (-255 / 2);
    linear_extrude(0.2, center = true)
    difference() {
        plate();      
        
        // all these parts have position using origin from centre,
        // which is why we need to divide the depths of part and the part before by 2
        top_01 = top_from_origin + 24;
        translate([0, top_01, 0])
            knobs();
        
        top_02 = top_01 + knobs_depth / 2 + screen_outer_depth / 2  + 4;
        translate([0, top_02, 0])
            screen();
        
        top_03 = top_02 + screen_inner_depth / 2 + row_03_depth_excluding_tempo / 2 + 9;
        translate([0, top_03, 0])
            row_03();
        
        top_04 = top_03 + row_03_depth_excluding_tempo / 2 + row_4_depth / 2 + 10;
        translate([0, top_04, 0])
            row_4();
        
        top_05 = top_04 + row_5_depth + 8;
        translate([0, top_05, 0])
            row_5();
//            
//        top_6 = top_05 + row_5_depth + 1 + 8;
//        translate([0, top_6, 0])
//            row_pads();
//            
//        top_7 = top_6 + row_pads_depth + 8;
//        translate([0, top_7, 0])
//            row_pads();
//            
//        top_8 = top_7 + row_pads_depth + 8;
//        translate([0, top_8, 0])
//            row_pads();
            
    }   
}

SP404SX();