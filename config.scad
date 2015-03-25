ex = 20; //extrusion, 20mm
gantry = [6, 10.75] * 25.4;
carriage = [5, 7] * 25.4;
dist = 13.5; //corner radius
ecc_rad = 7.2 / 2;
reg_rad = 5.00 / 2;
sep = 39.7;

spacer_sep = 30.32; //distance between wheels in the spacer block
spacer_thick = 13;

back_edge = 25;
motor_top = 30; //how far to move the motor above the rollers
top_offset = 20; //distance between motor top and top edge of y plates

x_rail = 40;
y_rail = 60;
z_rail = 40;

pulley_width = 20;
roller_rad = 24.39/2;

x_len = 500;
y_len = 500;
z_len = 250;

module slot(rad, width) {
    hull() {
        translate([-width/2,0]) circle(r=rad);
        translate([width/2,0]) circle(r=rad);
    }
}

module nema17(l=10, face=22.5) {
    $fn=64;
    sep = 31;
    screw = 3.0;
    
    slot(face/2, l);
    translate([-sep/2,-sep/2]) slot(screw/2, l);
    translate([-sep/2, sep/2]) slot(screw/2, l);
    translate([ sep/2,-sep/2]) slot(screw/2, l);
    translate([ sep/2, sep/2]) slot(screw/2, l);
}

module nema23(l=10) {
    $fn=64;
    sep = 47;
    screw = 5.05;
    translate([-sep/2,-sep/2]) slot(screw/2, l);
    translate([-sep/2, sep/2]) slot(screw/2, l);
    translate([ sep/2,-sep/2]) slot(screw/2, l);
    translate([ sep/2, sep/2]) slot(screw/2, l);
}