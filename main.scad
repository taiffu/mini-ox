include <config.scad>;
use <../lib/smallbridges/scad/vslot.scad>;
use <plate_y.scad>;
use <plate_x.scad>;
use <plate_misc.scad>;
use <spacer.scad>;

thick = 6.35;

full_machine();

module full_gantry(innerplate=false) {
    module sideplate_assembly() {
        linear_extrude(height=thick) sideplate();
        if (innerplate) {
            color("white") translate([0,0,-12.7-10.23]) linear_extrude(height=12.7+10.23) sideplate_pla();
            translate([0,0,-thick-6.35-10.23-6.35]) 
                linear_extrude(height=thick) sideplate_inner();
        }
    }
    
    translate([-250,0]) rotate([90,0, -90]) sideplate_assembly();
    translate([ 250,0]) mirror([1,0]) rotate([90,0, -90]) 
        sideplate_assembly();
    
    
    translate([-250,-back_edge-0.5*ex+1,gantry[1]-x_rail/2-top_offset]) rotate([0,90])
        color("gray") render() vslot20x40(500);
    translate([-250,-back_edge-1.5*ex-1,gantry[1]-x_rail/2-top_offset]) rotate([0,90])
        color("gray") render() vslot20x40(500);
    
    
    roller_top = dist+sep-ex+x_rail;
    mid = (roller_top+dist)/2;
    //x-z carriage
    translate([0,0,gantry[1]-x_rail-dist-(sep-ex)/2-top_offset]) {
        translate([0,thick-back_edge]) rotate([90,0]) 
            linear_extrude(height=thick) backplate();
        translate([0,-back_edge-2-2*ex]) {
            rotate([90,0]) linear_extrude(height=thick) frontplate();
            
            translate([0,-thick,mid]) rotate([90,0]) color("white") combined_spacer();
            
            //z rail
            translate([0,-ex/2-thick-13, -125]) color("gray") 
                render() vslot20x40(z_len);
            
            translate([0,-thick-13/2,z_len/2]) color("white") screwplate();
            translate([0,-thick-13/2,-z_len/2]) color("white") rotate([0,180]) bottomplate();
        }
    }
}

module full_machine() {
    translate([0,0,-(sep-ex)/2-dist+40]) {
        translate([0,gantry[0]/2]) full_gantry();
        //y_rail
        translate([-x_len/2+ex/2,-y_len/2, dist+y_rail/2+(sep-ex)/2]) 
            rotate([0,90,90]) color("gray") render() vslot20x60(y_len);
        translate([ x_len/2-ex/2,-y_len/2, dist+y_rail/2+(sep-ex)/2]) 
            rotate([0,90,90]) color("gray") render() vslot20x60(y_len);
    }
    
    module support_rail() {
        translate([-x_len/2,ex/2,ex]) {
            rotate([0,90,0]) color("gray") render() vslot20x40(x_len);
            translate([0,-ex/2]) rotate([90,0]) linear_extrude(height=thick) joinplate();
            translate([x_len,-ex/2-thick]) rotate([90,0,180]) linear_extrude(height=thick) joinplate();
        }
    }
    
    translate([0, -y_len/2]) support_rail();
    rotate([0,0,180]) translate([0,-y_len/2]) support_rail();
}

module cutplate(partsep = 10) {
    translate([partsep,partsep]) mirror([0,1]) rotate([0,0,-90]) sideplate();
    translate([partsep,2*gantry[0]+2*partsep]) rotate([0,0,-90]) sideplate();

    translate([partsep+carriage[0]/2,2*gantry[0]+3*partsep]) backplate();
    translate([partsep+carriage[0]*1.5+partsep,2*gantry[0]+3*partsep]) frontplate();

    translate([12*25.4-partsep,gantry[0]]) rotate([0,0,90]) joinplate();
    
    translate([partsep+carriage[0]-10, 2*gantry[0]+4*partsep+.75*carriage[0]]) joinplate();
    
    translate([partsep+carriage[0]+80, 2*gantry[0]+4*partsep+.75*carriage[0]+100]) rotate([0,0,180]) joinplate();
    
    translate([partsep+carriage[0]+88, 2*gantry[0]+4*partsep+.75*carriage[0]]) joinplate();
    
    %square([12, 24]*25.4);
}
