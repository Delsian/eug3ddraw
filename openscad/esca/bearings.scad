
cylinderFn = 16;

function BearingMR105ZZDiameter() = 10;
 
module BearingMR105ZZ() {
	height = 4;
	inner = 5;
	color ("silver") difference() {
		cylinder(d = BearingMR105ZZDiameter(), h = height, center = true, $fn=cylinderFn);
		translate([0,0,-0.1]) cylinder(d = inner, h = height+0.3, center = true, $fn=cylinderFn);
	}
}