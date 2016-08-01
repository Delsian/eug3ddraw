
include <diamond_hotend_assembly.scad>;
use <FanductOvalE3dv6_a.scad>

wall = 1.5;
kFanSize = 40;
fanAngleFromVert = 60;
heaterBlockW = 18;
ventedDuctMaxHeight = 22;
ventedDuctWidth = 16;
mountToHotEndBottomZ = 57.5; //vertical distance from center of mounting hinge to tip of nozzl


module main() {
	difference() {
		union() {
			retention();
			deflectors();
			duct();
			mounting();
		}
		
		union() {
			if (assembled == true) {
				coldend();
				hotend();
			} else {
				coldend();
			}
			
			wirehole();
			fan_mount_holes();
		}
	}
    
    rotate([0,-(90+fanAngleFromVert),180]) {
        fanduct_all();
    }
}

module fanduct_all() {
    union () {
        FanSplitter(mountToHotEndBottomZ,
            kFanSize,heaterBlockW,
            ventedDuctMaxHeight,ventedDuctWidth
            /*,mountToHeatBlockHorizontal*/);
        mirror([0,1,0]) 
            FanSplitter(mountToHotEndBottomZ, kFanSize,
                heaterBlockW, ventedDuctMaxHeight,
                ventedDuctWidth
                /*,mountToHeatBlockHorizontal*/);

        translate([-wall, -kFanSize/2, -8])
            afsplitter_new();
        translate([kFanSize/2+1, 0, -8])
            hinge_new();
    }
}