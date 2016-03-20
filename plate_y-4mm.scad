include <config.scad>;
thick = 4;

module _pla_screws() {
    s = 3.05 / 2;
    //translate([back_edge/2, gantry[1]-top_offset]) circle(r=s);
    //translate([back_edge/2, gantry[1]-top_offset-x_rail/2]) circle(r=s);
    translate([back_edge/2, gantry[1]-top_offset-x_rail-ex/2]) circle(r=s);
    translate([back_edge+10, gantry[1]-top_offset/2]) circle(r=s);
    translate([back_edge+30, gantry[1]-top_offset/2]) circle(r=s);
    //translate([back_edge+45+dist/2, gantry[1]-top_offset]) circle(r=s);
    //translate([back_edge+45+1.5*dist, gantry[1]-top_offset-x_rail/2]) circle(r=s);
    translate([back_edge+45+2.1*dist, gantry[1]-top_offset-x_rail-ex/2]) circle(r=s);
    
    //Add mount holes for l brackets
    translate([back_edge-15, gantry[1]-top_offset-x_rail+0.5*ex]) circle(r=reg_rad);
    translate([back_edge-15, gantry[1]-top_offset-x_rail+1.5*ex]) circle(r=reg_rad);
    translate([back_edge+2*ex+15, gantry[1]-top_offset-x_rail+0.5*ex]) circle(r=reg_rad);
    translate([back_edge+2*ex+15, gantry[1]-top_offset-x_rail+1.5*ex]) circle(r=reg_rad);
    
    
    //slot for belt
    translate([back_edge+ex-ex/2-1, gantry[1]-top_offset+1]) slot(1.5, 10);
    
    //slot for y motor wire
    translate([back_edge+ex/2, gantry[1]-top_offset-ex]) slot(1.5, 12);
}    

module side(nema_face=22.5) {
    roller_top = dist+sep-ex+y_rail;
    difference() {
        offset(dist) offset(-dist) polygon([
            [0,0],
            [gantry[0],0],
            [gantry[0],sep-ex+y_rail+2*dist], 
            [back_edge+2*ex+dist,gantry[1]],
            [0,gantry[1]]
        ]);
        
        //bottom rollers
        translate([dist, dist]) circle(r=ecc_rad);
        translate([gantry[0]/2, dist]) circle(r=ecc_rad);
        translate([gantry[0]-dist, dist]) circle(r=ecc_rad);
        //top rollers
        translate([dist,roller_top]) circle(r=reg_rad);
        translate([gantry[0]/2, roller_top]) circle(r=reg_rad);
        translate([gantry[0]-dist,roller_top]) circle(r=reg_rad);
        //motor
        translate([gantry[0]/4+dist/2, roller_top+motor_top]) 
            rotate([0,0,90]) nema17(face=nema_face);
        
        //tiedown for wires
        translate([gantry[0]/4+dist/2, roller_top+motor_top+40]) {
            translate([-ex/2,0]) circle(r=reg_rad);
            translate([ ex/2,0]) circle(r=reg_rad);
        }
    }
}

module sideplate() {
    $fn=64;
    
    roller_top = dist+sep-ex+y_rail;
    render() linear_extrude(height=thick) difference() {
        side();
        //x-axis rails
        translate([back_edge+ex, gantry[1]-0.5*ex-top_offset]) 
            slot(reg_rad, ex+5);
        translate([back_edge+ex, gantry[1]-1.5*ex-top_offset]) 
            slot(reg_rad, ex+5);
            
        _pla_screws();
    }
}

module sideplate_inner() {
    $fn=64;
    roller_top = dist+sep-ex+y_rail;
    render() difference() {
        side(nema_face=6);
        
        //x-axis rails
        translate([back_edge+ex-45/2,gantry[1]-x_rail-top_offset]) square([45,40]);
        
            
        //PLA block screws
        _pla_screws();
    }
}

module sideplate_pla() {
    intersection() {
        sideplate_inner();
        translate([0,gantry[1]-top_offset-x_rail-ex]) square([gantry[0], gantry[1]]);
    }
}

sideplate();