
/*
 * SCARA arm
 */
 
use <../lib/gears/parametric_involute_gear_v5.0.scad>;
use <pipe.scad>;
use <ISOThread.scad>;
use <gears.scad>;

// Arm sizes in mm
// first segment
ARM_LENGTH_NEAR = 300;
ARM_LENGTH_FAR = 200;

PVC_PIPE_DIAMETER = 32;

module arm_near() {
    // PVC pipe as shell
	%rotate([0,90,0])
        pipe32(len=ARM_LENGTH_NEAR);
    
    // Sides
    near_arm_mount_near();
	translate([ARM_LENGTH_NEAR, 0, 0])
		rotate([0,0,180])
			near_arm_mount_far();

    // Threaded rods inside PVC pipe
    for(i=[0,120,240])
    {
        rotate([i,0,0])
            translate([0,0,(PVC_PIPE_DIAMETER/3)])
                rotate([0,90,0])
                    //union() {
                        cylinder(ARM_LENGTH_NEAR, 2, 2);
                        //thread_out(4,10);
                    //}
    }
}

module arm_far() {
}

// Far end of first arm
module near_arm_mount_far() {
    holder_w = 70;
    holder_h = 40;
	pipe_holder(h=holder_h,w=holder_w);
}

module near_arm_mount_near() {
	holder_w = 70;
    holder_h = 40;
    plate_h = 50;
    wall = 5;
	pipe_holder(h=holder_h,w=holder_w);
    translate([-(plate_h-wall)/2, 0, -holder_h/2]) {
        cube([plate_h,holder_w,wall], center=true);
    }
}

translate([-60,0,0]) GearSet();
//arm_near();
//near_arm_mount_near();
