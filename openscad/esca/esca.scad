
/*
 * SCARA arm
 */
 
use <../lib/gears/parametric_involute_gear_v5.0.scad>
 
module pipe( dia=10, w=1, len=100) {
	difference() {
		cylinder(h=len,r=dia/2);
		translate ([0,0,-1]) {
			cylinder(h=len+2,r=dia/2 - w);
		}
	}
}
 
module pipe32( len = 100) {
    pipe(dia=32.2, w=1.9);
}

bevel_gear_pair (
	gear1_teeth = 80,
	outside_circular_pitch=1000);
