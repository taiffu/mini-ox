nut = [5.7, 2.6, 3.2]; //m4 width across flats, thickness
module pulley(diam, bore, groove=.125*25.4, thick=8, gap=1.5) {
    module nut_trap() {
        translate([bore/2+gap,-nut[0]/2, -1]) cube([nut[1], nut[0], thick+2]);
        translate([0,0,thick/2]) rotate([0,90]) cylinder(r=nut[2]/2, h=diam+1, $fn=32);
    }
    width = diam/2 - groove/2 - bore/2;
    difference() {
        render(convexity=5) rotate_extrude($fn=128) difference() {
            translate([bore/2,0]) square([width, thick]);
            translate([diam/2-groove/2,thick/2]) circle(r=groove/2, $fn=64);
        }
        nut_trap();
        rotate([0,0,180]) nut_trap();
    }
}

pulley(29.5, 10);

translate([49.3,0]) pulley(22, 4);