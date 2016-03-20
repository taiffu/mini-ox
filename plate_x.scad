include <config.scad>;
bthick = 4; //minimum thickness of wall behind bearing
thick = 4;

module backplate() {
    $fn=64;
    motor_top = 27;
    roller_top = dist+sep-ex+x_rail;
    
    render() linear_extrude(height=thick) difference() {
        offset(dist) offset(-dist) 
        polygon([
            [-carriage[0]/2, 0], [carriage[0]/2,0],
            //edge inset
            [ carriage[0]/2, 1.5*dist],
            [ carriage[0]/2-dist, 2.5*dist],
            [ carriage[0]/2-1.2*dist, roller_top-1.5*dist],
            [ carriage[0]/2, roller_top-dist/2],
            
            [ carriage[0]/2-dist/4, roller_top+.75*dist],
            [ carriage[0]/2-1.5*dist, roller_top+1.75*dist],
            [ dist/2+42.3/2, roller_top+dist+motor_top+42.3/2],
            [-dist/2-42.3/2, roller_top+dist+motor_top+42.3/2],
            [-carriage[0]/2+1.5*dist, roller_top+1.75*dist],
            [-carriage[0]/2+dist/4, roller_top+.75*dist],
        
            //edge inset
            [-carriage[0]/2, roller_top-dist/2],
            [-carriage[0]/2+1.2*dist, roller_top-1.5*dist],
            [-carriage[0]/2+dist, 2.5*dist],
            [-carriage[0]/2, 1.5*dist],
        ]);
        
        //rollers
        translate([-carriage[0]/2+dist,dist]) circle(r=ecc_rad);
        translate([ carriage[0]/2-dist,dist]) circle(r=ecc_rad);
        translate([-carriage[0]/2+dist,roller_top]) circle(r=reg_rad);
        translate([ carriage[0]/2-dist,roller_top]) circle(r=reg_rad);
        
        
        //center cutout
        /*offset(dist) offset(-dist) polygon([
            [ carriage[0]/2-2.5*dist, 2*dist],
            [ carriage[0]/2-2.7*dist, roller_top-dist],
            [-carriage[0]/2+2.7*dist, roller_top-dist],
            [-carriage[0]/2+2.5*dist, 2*dist],
        ]);*/
        
        //translate([0, roller_top+motor_top]) rotate([0,0,90]) nema23();
        translate([0, roller_top+motor_top]) rotate([0,0,90]) nema17();
    }
}

module frontplate() {
    $fn=64;
    roller_top = dist+sep-ex+x_rail;
    mid = (roller_top+dist)/2;
    zsep = sep-ex+z_rail;
    
    render() linear_extrude(height=thick) difference() {
        offset(dist) offset(-dist) 
        polygon([
            [-carriage[0]/2, 0], 
            //bottom inset
            [-carriage[0]/2+3*dist,0],
            [-10,dist],
            [ 10,dist],
            [ carriage[0]/2-3*dist,0],
        
            [carriage[0]/2,0],
            //edge inset
            [ carriage[0]/2, 1.5*dist],
            [ carriage[0]/2-dist, 2.5*dist],
            [ carriage[0]/2-1.2*dist, roller_top-1.5*dist],
            [ carriage[0]/2, roller_top-dist/2],
            
            [ carriage[0]/2-dist/4, roller_top+dist],
            //top inset
            [-carriage[0]/2+3*dist,roller_top+dist],
            [-10,roller_top],
            [ 10,roller_top],
            [ carriage[0]/2-3*dist,roller_top+dist],
        
            [-carriage[0]/2+dist/4, roller_top+dist],
        
            //edge inset
            [-carriage[0]/2, roller_top-dist/2],
            [-carriage[0]/2+1.2*dist, roller_top-1.5*dist],
            [-carriage[0]/2+dist, 2.5*dist],
            [-carriage[0]/2, 1.5*dist],
        ]);
        
        //rollers
        translate([-carriage[0]/2+dist,dist]) circle(r=ecc_rad);
        translate([ carriage[0]/2-dist,dist]) circle(r=ecc_rad);
        translate([-carriage[0]/2+dist,roller_top]) circle(r=reg_rad);
        translate([ carriage[0]/2-dist,roller_top]) circle(r=reg_rad);
        
        //acme block mount
        translate([-10, mid]) circle(r=reg_rad);
        translate([ 10, mid]) circle(r=reg_rad);
        
        //Z rollers
        translate([0,mid]) {
            translate([ zsep/2,-spacer_sep]) circle(r=ecc_rad);
            translate([ zsep/2, spacer_sep]) circle(r=ecc_rad);
            //translate([ zsep/2,-10]) circle(r=reg_rad);
            //translate([ zsep/2,10]) circle(r=reg_rad);
            //translate([ zsep/2,0]) circle(r=ecc_rad);
            //translate([-zsep/2,0]) circle(r=reg_rad);
            //translate([-zsep/2, 10]) circle(r=reg_rad);
            //translate([-zsep/2,-10]) circle(r=reg_rad);
            translate([-zsep/2, spacer_sep]) circle(r=reg_rad);
            translate([-zsep/2,-spacer_sep]) circle(r=reg_rad);
        }
    }
}

translate([0,-100]) frontplate();
backplate();