//
// Diamond Hotend Assembly
// 
// This is an OpenSCAD script for generating the parts necessary for proper operation of The Diamond Hotend by RepRap.me
// for further info see http://reprap.org/wiki/Diamond_Hotend
//
// This code is published under Creative Commons CC-BY-SA license 2015 for RepRap.me by Kharar
// In plain english this means that you may download, use and modify this code as you like as long as you make your new version available under the same license
// For further info see http://creativecommons.org/licenses/
//

DiamondParts = function() {

	var ziptie_enable = true;
	var angle = 28;						// filament entrance bore angle
	var coldend_offset = (24.5-5)+7;	// total distance from point of origin at center joint chamber to the lower side of cooling fins
	
	var fan_pos = 68.5;					// cooling fan distance to origin
	var fan_plate = 3.5;				// cooling fan mounting bracket thickness
	var fan_width = 40;					// cooling fan outer dimensions (works with 40 or 50 only!)
	
	var flange_h = 24;					// conical funnel part
	var radius_up = fan_width/2-2;		// funnel radius at upper end
	var radius_lo = 24/2;				// funnel radius at lower end
	var radius_lo_center = 3.5;			// hole for wires at lower end
	
	var retention_amount = 1.2;			// metal parts rest point snap-in amount
	var retention_width = 10;			// metal parts rest width
	var retention_offset = Math.sin(angle)*(coldend_offset+26+7+6)-Math.cos(angle)*(16/2) + retention_amount;
	var retention_thickness = retention_offset - radius_up;

	// Coldend zip-tie
	var ziptie = function(ziptie_en) {
		var z = [];
		for (var j=-1; j <= 1; j++) {
			z.push( translate([-8, j*6, 6-1.5],
				rotate([0, 0, 0],
					cube([16, 1.5, 3.01], center=true))));
		}
	
		if (ziptie_en === true)
			return z;
		else
			return [];
	}

	//E3D coldends
	DiamondParts.ColdEnd = function(params) {
		var ce = CSG.cube({radius: 1});
		return ce;
	}
	
	DiamondParts.coldend = function(params) {
		var wall = params.wall;
		
		var c = [];
	
		for( var i = 0; i < 270; i +=120 ) {
			c.push( 
				rotate([0, 0, i],
					rotate([0, angle, 0],
						union(
							translate([0, 0, coldend_offset-tolerance],
								union(
									cylinder(r=22/2+tolerance, h=26+2*tolerance),
									
									translate([0, 0, 26],
										union(
											translate([0, 0, -1],
												cylinder(r=16/2+tolerance, h=7+1+tolerance)),
											
											translate([0, 0, 7],
												union(
													translate([0, 0, -1],
														cylinder(r=12/2+tolerance, h=6+2)),
													translate([0, 0, 6-tolerance],
														cylinder(r=16/2+tolerance, h=3.75+2*tolerance)),
													
													//holes for zip-ties
													ziptie (ziptie_enable)
												)
											)
										)
									),
									rotate([180, 0, 0],
										cylinder(h=4, r=6/2))
								)
							)
						)
					)
				)
			)
		}
		
		return c;
	}

	DiamondParts.retention = function() {
		var r = [];
		for( var i = 0; i<270; i+=120) {
			r.push (
			    rotate([0, 0, i],
			        translate([radius_up, -retention_width/2, fan_pos-16],
				        cube([retention_thickness, retention_width, 16]))));
		}
		return r;
	}

} // DiamondParts
