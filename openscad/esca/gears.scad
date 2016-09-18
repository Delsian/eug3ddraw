use <../lib/Thread_Library.scad>
use <MCAD/involute_gears.scad>
use <ISOThread.scad>;

numberTeeth=35;
pitchRadius=40;
thickness=15;


length=50;
radius=12;
pitch=2*3.1415*pitchRadius/numberTeeth;

angle=-360*$t;
offset=2;
circles=6;
distance=radius+pitchRadius+0.0*pitch;

// diameter of driving threaded rod from stepper
source_rod=5;

module GearSet()
{
	translate([length/2,0,0])
	rotate([0,90,180+angle])
		GearsWorm();

	translate([0,-distance,-thickness/2])
		rotate([0,0,offset-angle/numberTeeth])
			GearsGear();
}

module GearsWorm() {
	difference() {
		trapezoidThread( 
			length=length, 			// axial length of the threaded rod
			pitch=pitch,				 // axial distance from crest to crest
			pitchRadius=radius, 		// radial distance from center to mid-profile
			threadHeightToPitch=0.5, 	// ratio between the height of the profile and the pitch
								// std value for Acme or metric lead screw is 0.5
			profileRatio=0.5,			 // ratio between the lengths of the raised part of the profile and the pitch
								// std value for Acme or metric lead screw is 0.5
			threadAngle=25, 			// angle between the two faces of the thread
								// std value for Acme is 29 or for metric lead screw is 30
			RH=true, 				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
			clearance=0.2, 			// radial clearance, normalized to thread height
			backlash=0.06, 			// axial clearance, normalized to pitch
			stepsPerTurn=24 			// number of slices to create per turn
			);
		translate ([0,0,-.5]) cylinder(h=length*1.1, d=source_rod*1.1);
		translate ([0,0,-.5]) hex_nut(source_rod);
	}
}

module GearsGear() {
	translate([0,0,thickness/2])
	rotate([90,0,0])
	for (i=[0:circles]) {
		rotate([0,360/circles*i],0)
		translate([0,0,8])
		cylinder(d=thickness*0.8,h=26);
	}
	gear ( 
		number_of_teeth=numberTeeth,
		circular_pitch=360*pitchRadius/numberTeeth,
		pressure_angle=20,
		clearance = 0,
		gear_thickness=thickness/2,
		rim_thickness=thickness,
		rim_width=5,
		hub_thickness=thickness,
		hub_diameter=20,
		bore_diameter=10,
		circles=circles,
		backlash=0.1,
		twist=-pitchRadius/radius,
		involute_facets=0,
		flat=false);
}