include <config.scad>;
use <misc_parts.scad>;

msep = 31;
screw = 3.4;
bearing = [10, 16.5, 5];
bthick = 2; //minimum thickness of wall behind bearing

zbase = msep/sqrt(2);

screwplate();
translate([60,0]) bottomplate();

module joinplate() {
    corner = 5;
    $fn=64;
    render() difference() {
        offset(corner) offset(-corner) polygon([
            [0,0],[60,0], [60,20],[20,80],[0,80]
        ]);
        
        //translate([ex*.5, 3.5*ex+6]) slot(1.5,6);
        
        translate([ex*.5, ex*.5]) circle(r=reg_rad);
        translate([ex*1.5, ex*.5]) circle(r=reg_rad);
        translate([ex*2.5, ex*.5]) circle(r=reg_rad);
        translate([ex*.5, ex*1.5]) circle(r=reg_rad);
        translate([ex*.5, ex*2.5]) circle(r=reg_rad);
        translate([ex*.5, ex*3.5]) circle(r=reg_rad);
    }
}

module zplate_holes(slot_length=5) {
    //bearing bore + 1mm radius margin
    circle(r=bearing[0]/2+1, $fn=32);
    
    //slots for extrusion mounting
    translate([-ex/2,-spacer_thick/2-slot_length/2-ex/2+2]) 
        rotate([0,0,90]) slot(reg_rad+.15, slot_length, $fn=16);
    translate([ ex/2,-spacer_thick/2-slot_length/2-ex/2+2]) 
        rotate([0,0,90]) slot(reg_rad+.15, slot_length, $fn=16);
}

module screwplate(thick=6.35, slot_length=6) {
    bottom = spacer_thick/2+ex*.25+slot_length;
    module screwhole(flip=false) {
        t = thick - 2*bthick;
        
        translate([0,0,-1]) cylinder(r=3, h=1+thick-5, $fn=32);
        translate([0,0,thick-5]) cylinder(r1=3, r2=screw/2, h=2, $fn=32);
        translate([0,0,3]) cylinder(r=screw/2, h=thick+2, $fn=32); 
    }
    difference() {
        render(convexity=10) linear_extrude(height=thick) difference() {
            offset(10) polygon([
                [-zbase, 0], [0, zbase], [zbase,0], 
                [zbase,-bottom], [-zbase, -bottom]
            ]);
            
            zplate_holes(slot_length=slot_length);
        }
        translate([0,0,bthick]) cylinder(r=bearing[1]/2, h=thick, $fn=32);
        
        translate([-zbase,0]) screwhole();
        translate([0, zbase]) screwhole();
        translate([ zbase,0]) screwhole();
    }
    
   /* translate([0,0,thick-1]) rotate([0,0,45]) {
        motor_spacer(width=12, height=43);
        rotate([0,0,90]) motor_spacer(width=12, height=43);
        rotate([0,0,-90]) motor_spacer(width=12, height=43);
    }*/
}

module bottomplate(thick=6.35, slot_length=6) {
    bottom = spacer_thick/2+ex*.75+slot_length;
    difference() {
        render(convexity=10) linear_extrude(height=thick) difference() {
            offset(10) offset(-10) polygon([
                [-z_rail/2, -bottom],[-z_rail/2,0],
                [0, bearing[1]],
                [z_rail/2, 0],[z_rail/2,-bottom],
            ]);
            
            zplate_holes(slot_length=slot_length);    
        }
        
        translate([0,0,bthick]) cylinder(r=bearing[1]/2, h=thick, $fn=32);
    }
}