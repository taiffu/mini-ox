bearing = [10, 30, 14.287];
tube = [1.32*25.4, 75];

back = 8;
thick = 20; //thickness of clamp
screw = [5.5, 11, 2]; //diameter, head width, head countersink 
nut = [8.2, 5, 9]; //diameter, thickness, depth
gap = 0.2;
wing = 12; //sideways wings
wheelbase = 48.6; //separation between spindle and motor shaft
motor = [28, 19, 3.2]; //diameter, screw separation, screw diameter

module spindle() {
    %cylinder(r=1.32*25.4/2, h=tube);
    cylinder(r=bearing[1]/2, h=bearing[2]);
    translate([0,0,tube-bearing[2]]) cylinder(r=bearing[1]/2, h=bearing[2]);

    color("gray") cylinder(r=bearing[0]/2, h=100);
    translate([0,0,-20]) color("black") cylinder(r=8, h=20);
}

module motorslots(l=5, shaft=16, screw=7) {
    $fn=32;
    r = motor[0]/sqrt(2)+10/sqrt(2);
    
    module s() {
        translate([0,0,-1]) hull() {
            translate([-l/2,0]) cylinder(r=motor[2]/2, h=thick+2); 
            translate([ l/2,0]) cylinder(r=motor[2]/2, h=thick+2);
        }
    }
    //shaft
    translate([0,0,-1]) hull() {
        translate([-l/2,0]) cylinder(r=shaft/2, h=thick+2);
        translate([l/2,0]) cylinder(r=shaft/2, h=thick+2);
    }
    translate([-r/2,-r/2]) s();
    translate([ r/2, r/2]) s();
    translate([-r/2, r/2]) s();
    translate([ r/2,-r/2]) s();
}

module holder(mount = 2) {
    width = tube[0] + 2*wing;
    top = back+wing+tube[0];
    tabthick = 6.35;
    
    module form() {
        module fillet() {
            translate([0, thick*1.5, back+tube[0]/2]) 
                rotate([0,90]) 
                scale([tube[0]/2, thick]) 
                cylinder(r=1, h=width, center=true, $fn=128);
            translate([-width/2, thick/2, back+tube[0]/2]) 
                cube([width, thick, tube[0]/2+wing]);
        }
        difference() {
            linear_extrude(height=top) offset(10) offset(-10) polygon([
                [-mount*10, 1.5*thick], [mount*10, 1.5*thick],
                [width/2, thick/2],[width/2,-thick/2],
                [mount*10, -1.5*thick], [-mount*10, -1.5*thick], 
                [-width/2, -thick/2], [-width/2, thick/2], 
            ]);
        
            //fillets for holder
            fillet();
            mirror([0,1]) fillet();
        }
    };
    
    module smooth() {
        render(convexity=10) intersection() {
            form();
            union() {
                translate([0,0,back+tube[0]]) rotate([90,0]) scale([width/2, wing]) cylinder(r=1, h=3*thick, center=true, $fn=128);
                translate([-width/2, -1.5*thick]) cube([width, 3*thick, back+tube[0]]);
            }
        }
        
        //motor tab
        corner = 5;
        margin = ((tube[0]+back)/2-corner);
        translate([0,thick/2-tabthick]) hull() {
            translate([wheelbase+margin,0, back+tube[0]-corner]) 
                rotate([-90,0]) cylinder(r=corner, h=tabthick);
            cube([wheelbase+margin+corner, tabthick, 1]);
            cube([1, tabthick, back+tube[0]]);
        }
    }
    
    module screwhole(d=0, l=50) {
        translate([0,0,d-l]) cylinder(r=screw[0]/2, h=l+1);
        translate([0,0,d]) cylinder(r=screw[1]/2, h=2*l);
    }
    module screwnut() {
        screwhole(back+tube[0]/2+back, l=2*back-0.2);
        translate([0,0,-1]) cylinder(r=screw[0]/2, h=tube[0]/2-nut[1]+2);
        translate([-nut[0]/2, -nut[2]/2,tube[0]/2-nut[1]])
            cube([nut[0], 3*thick, nut[1]]);
    }
    
    off = sqrt(wheelbase*wheelbase - 4*4);
    
    difference() {
        smooth(); 
        //tube
        translate([0,0,back+tube[0]/2]) rotate([90,0]) cylinder(r=tube[0]/2, h=4*thick, $fn=128, center=true);
        
        //motor holder
        translate([off, 0, (back+tube[0])/2]) rotate([-90,0]) {
            motorslots();
            //xmount();
        }
        
        for (i=[0:mount-1]) {
            translate([i*20-10, thick]) screwhole(back-screw[2]);
            translate([i*20-10,-thick]) screwhole(back-screw[2]);
        }
        
        //holder screws
        translate([-tube[0]/2-wing/2,0]) {
            screwnut();
        }
        translate([ tube[0]/2+wing/2,0]) {
            screwnut();
        }
    }
}

module diffcube(gap) {
    translate([-tube[0]/2-wing-1,-thick/2-1,back+tube[0]/2+gap/2])
        cube([tube[0]+2*wing+1, thick+2, tube[0]/2+wing+2]);
}

module xmount(bar=10) {
    $fn=32;
    width = motor[0]/sqrt(2)+bar/sqrt(2);
    module outline() {
        hull() {
            translate([-width/2,-width/2]) circle(r=bar/2);
            translate([ width/2, width/2]) circle(r=bar/2); 
        }
        hull() {
            translate([-width/2, width/2]) circle(r=bar/2);
            translate([ width/2,-width/2]) circle(r=bar/2);
        }
        circle(r=motor[0]/2);
    }
    difference() {
        render(convexity=5) linear_extrude(height=2) difference() {
            outline();
            circle(r=4);
            translate([-width/2,-width/2]) circle(r=2);
            translate([ width/2, width/2]) circle(r=2);
            translate([-width/2, width/2]) circle(r=2);
            translate([ width/2,-width/2]) circle(r=2);
        }
        
        translate([-19/2/sqrt(2), -19/2/sqrt(2), -.01]) cylinder(r1=1.5, r2=3, h=2.02);
        translate([ 19/2/sqrt(2),  19/2/sqrt(2), -.01]) cylinder(r1=1.5, r2=3, h=2.02);
        
        translate([ 16/2/sqrt(2), -16/2/sqrt(2), -.01]) cylinder(r1=1.5, r2=3, h=2.02);
        translate([-16/2/sqrt(2),  16/2/sqrt(2), -.01]) cylinder(r1=1.5, r2=3, h=2.02);
    }
}

//holder();
//xmount();

difference() {
    holder();
    diffcube(-gap);
}

translate([0, -10, thick/2]) rotate([90,0]) 
intersection() {
    holder();
    diffcube(gap);
}
