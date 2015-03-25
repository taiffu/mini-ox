module wheel_spacer(width=10, thick=6.5, screw=5.5, $fn=128) {
    difference() {
        cylinder(r=width/2, h=thick);
        translate([0,0,-1]) cylinder(r=screw/2, h=thick+2);
    }
}

nema17 = [42.3, 31, 24, 3.6]; //width, screw width, face width,
module motor_spacer(width=15, height=36, motor=nema17) {
    base = motor[0]/2 - width;
    linear_extrude(height=height) offset(1, $fn=128) offset(-1) difference() {
        polygon([[base,base],[motor[0]/2,base],[motor[0]/2,motor[1]/2],[motor[1]/2,motor[0]/2],[base,motor[0]/2]]);
        circle(r=motor[2]/2, $fn=64);
        translate([motor[1]/2, motor[1]/2]) circle(r=motor[3]/2, $fn=32);
    }
}

wheel_spacer();

motor_spacer();
