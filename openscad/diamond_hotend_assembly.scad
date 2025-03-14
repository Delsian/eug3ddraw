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


assembled = true;				// for normal render mode set false - to see assembled with metal parts set true
metalPartsOnly = false;			// render hotend and coldend only (for subtractive purposes) NB. All coldend sirfaces are added with the tolerance.
ziptie_enable = true;			// holes for zip-tie mounting of the coldends
blower_enable = false;			// Experimental: optional 5015S blower fan for cooling extruded material (optimal positioning still untested)

tolerance = 0.1;				// plastic/metal parts fitting tolerance




// internal variables, generally you don't need to change these

$fn = 100;

angle = 28;						// filament entrance bore angle

coldend_offset = (24.5-5)+7;	// total distance from point of origin at center joint chamber to the lower side of cooling fins

flange_offset2 = -1;			// lower air stop

wall = 2.5;						// general wall thickness
wall_thin = 1;					// fine details

fan_pos = 68.5;					// cooling fan distance to origin
fan_plate = 3.5;				// cooling fan mounting bracket thickness
fan_width = 40;					// cooling fan outer dimensions (works with 40 or 50 only!)

flange_h = 24;					// conical funnel part
radius_up = fan_width/2-2;		// funnel radius at upper end
radius_lo = 24/2;				// funnel radius at lower end
radius_lo_center = 3.5;			// hole for wires at lower end

mounting_offset = 10;			// Mounting holes offset (effective nozzle height adjustment)
mounting_distance = 30.5;		// Mounting holes distance
mounting_thickness = 5;			// Mounting plate thickness

retention_amount = 1.2;			// metal parts rest point snap-in amount
retention_width = 10;			// metal parts rest width

blower_screwpos = 40;
blower_screwpos_X1 = -20.15;
blower_screwpos_Y1 = 20.3;
blower_screwpos_X2 = 22;
blower_screwpos_Y2 = -19.5;
blower_X = 51.2;
blower_Y = 51.2;
blower_Z = 15;
blower_output_X = 19;
blower_output_Y = 11;
blower_output_screw_Y = -6.5;
blower_output_screw_X = 9.5;
blower_angle = 150;
blower_offset_R = radius_up;
blower_offset_Z = 26;
blower_mount_dist = 11;
blower_mount_height = fan_pos-coldend_offset-flange_h;
blower_bracket_thickness = 2.2;
blower_bracket_countersunk_d_small = 3.3;
blower_bracket_countersunk_d_large = 7;


//calculations
pythagoras=sqrt((22/2)*(22/2)+coldend_offset*coldend_offset);
flange_offset = pythagoras-coldend_offset;			// lower air stop
fan_mount_dist = (fan_width == 50) ? 40 : 32;		// cooling fan mounting hole distance (if fan_width=50 then fan_mount_dist=40 and if fan_width=40 then fan_mount_dist=32)

retention_offset = sin(angle)*(coldend_offset+26+7+6)-cos(angle)*(16/2) + retention_amount;
retention_thickness = retention_offset - radius_up;



if (metalPartsOnly == false) {
	main();
} else {
	hotend();
	coldend();
}

//E3D coldends
module coldend() {
	for(i = [0: 120: 270]) {
		rotate([0, 0, i])
		rotate([0, angle, 0])
		union() {
			
			translate([0, 0, coldend_offset-tolerance])
			union() {
				cylinder(r=22/2+tolerance, h=26+2*tolerance);
				
				translate([0, 0, 26])
				union() {
					translate([0, 0, -1])
					cylinder(r=16/2+tolerance, h=7+1+tolerance);
					
					translate([0, 0, 7])
					union() {
						translate([0, 0, -1])
						cylinder(r=12/2+tolerance, h=6+2);
						
						translate([0, 0, 6-tolerance])
						cylinder(r=16/2+tolerance, h=3.75+2*tolerance);
						
						//holes for zip-ties
						if (ziptie_enable == true)
						for (j=[-1, 1])
						translate([-8, j*6, 6-1.5])
						rotate([0, 0, 0])
						cube([16, 1.5, 3.01], center=true);
					}
				}
				
				rotate([180, 0, 0])
				cylinder(h=4, r=6/2);
			}
		}
	}
}


module hotend() {   // Diamond mock-up
	difference() {
		translate([0, 0, -1.4])
		union() {
			cylinder(r1=1, r2=13.4, h=18.8);
			
			translate([0, 0, 18.8])
			cylinder(r=13.4, h=2.35);
			
			translate([0, 0, 18.8+2.35])
			cylinder(r1=13.4, r2=3, h=5);
		}
	}
}


module retention() {
	for(i = [0: 120: 270]) {
		rotate([0, 0, i])
		translate([radius_up, -retention_width/2, fan_pos-16])
		cube([retention_thickness, retention_width, 16]);
	}
}


//fan_mockup
module fan() {
	difference() {
		union() {
			hull()
			for(x = [-1, 1])
			for(y = [-1, 1])
			translate([x*(fan_width/2-4), y*(fan_width/2-4), fan_pos+15/2])
			cylinder(r=3.5, h=15, center=true);
		}
		
		union() {
			translate([0, 0, fan_pos+15/2])
			cylinder(r=fan_width/2-2, h=15+1, center=true);
		}
	}
}


//fan_mount
module fan_mount() {
	translate([0, 0, fan_pos])
	hull()
	for(i = [1: 4]) {
		rotate([0, 0, i*90])
		translate([fan_mount_dist/2, fan_mount_dist/2, -fan_plate/2])
		union() {
			cylinder(r=4.5, h=fan_plate, center= true);
			
			rotate([0, 0, 45])
			translate([-2*4.5, -4.5, -fan_plate/2])
			cube([2*4.5, 2*4.5, fan_plate]);
		}
	}
}


//fan_mount holes
module fan_mount_holes() {
	translate([0, 0, fan_pos])
	for(i = [1: 4])
		rotate([0, 0, i*90])
		translate([fan_mount_dist/2, fan_mount_dist/2, -fan_plate/2])
		rotate([180, 0, 0])
		cylinder(r=3.4/2, h=fan_plate+1, center=true);
}


//fan_duct
module duct() {
	difference() {
		union() {
			translate ([0, 0, coldend_offset+flange_h])
			cylinder(r=radius_up+wall, h=fan_pos-coldend_offset-flange_h);
			
			fan_mount();
		}
		
		//make the upper cylinder hollow
		union() {
			difference() {
				union() {
					translate ([0, 0, coldend_offset+flange_h-1])
					cylinder(r=radius_up, h=fan_pos-coldend_offset-flange_h+2);
				}
				
				union() {
					//except coldend mounting reinforcement
					coldend_reinforcement ();
				}
			}
		}
	}
}


module coldend_reinforcement () {
	union() {
		for(i = [0: 120: 270]) {
			rotate([0, 0, i])
			rotate([0, angle, 0])
			translate([0, 0, coldend_offset-tolerance+26])
			cylinder(r=16/2+wall/2, h=7+6+3.75+wall_thin);
		}
	}
}


//Side deflectors
module deflectors() {
	translate([0, 0, coldend_offset+flange_offset2])
	difference() {
		union() {
			cylinder(h=flange_h-flange_offset2, r1=radius_lo+wall, r2=radius_up+wall);
			
			if (blower_enable == true) {
				translate([0, 0, -(coldend_offset+flange_offset2)])
				blower_plate_screw_wall();
			}
		}
		
		translate([0, 0, -0.01])
		union() {
			//bottom cut
			translate([0, 0, 0.01-coldend_offset-flange_offset2])
			sphere(r=pythagoras);
			
			//bottom center hole
			translate([0, 0, flange_offset])
			cylinder(h=flange_offset+0.2, r=radius_lo_center);
			
			//hollow
			translate([0, 0, wall_thin])
			difference() {
				union() {
					difference() {
						union() {
							cylinder(h=flange_h-flange_offset2+0.2-wall_thin, r1=radius_lo, r2=radius_up);
						}
						
						union() {
							//additional coldend mounting reinforcement
							translate([0, 0, -wall_thin+0.01-flange_offset2-coldend_offset])
							coldend_reinforcement ();
							
							//bottom air stop
							translate([0, 0, 0.01-coldend_offset-flange_offset2-wall_thin])
							sphere(r=pythagoras+wall_thin);
						}
					}
				}
				
				translate([0, 0, flange_offset+wall_thin])
				union() {
					//bottom air stop support
					for (i= [0, 120, 240]) {
						rotate([0, 0, i])
						translate([-radius_lo_center, 0, 0])
						rotate([0, -49, 0])				// 38 minimum
						union() {
							//primary support
							translate([0, wall_thin/2, 0])
							rotate([0, 0, 180])
							cube([10, wall_thin, 100]);
							
							//secondary support
							rotate([0, 90, 180])
							rotate([0, 0, 135])
							translate([0, 0, wall_thin/2])
							cube([3, 3, wall_thin], center=true);
						}
					}
				}
			}
		}
	}
}


//Hole for wires
module wirehole() {
	translate([-fan_width/2, 0, fan_pos])
	rotate([0, 160, 0])
	union() {
		cylinder(r=8/2, h=2*(fan_pos-coldend_offset-flange_h), center=true);
		
		//zip-tie holes
		translate([0, 0, fan_pos-coldend_offset-flange_h])
		for (j=[-1, 1]) {
			translate([0, j*(8/2-1.5), 6-1.5])
			cube([30, 1.5, 3.01], center=true);
		}
	}
}


//mounting bracket for attaching to the x-carriage
module mounting() {
	translate([-radius_up, 0, fan_pos])
	difference() {
		union() {
			translate([-mounting_thickness, -20, -(fan_pos-coldend_offset-flange_h)])
			cube([mounting_thickness, 40, fan_pos-coldend_offset-flange_h]);
		}
		
		for(i = [-1, 1]) {
			translate([0.1, i*mounting_distance/2, -mounting_offset])
			rotate([0, 270, 0])
			union() {
				cylinder(h=mounting_thickness+1, r=3.3/2);
				cylinder(h=2, r=6.5/2, $fn=6);
			}
		}
	}
}


//optional 5015S blower fan mockup
module blower() {
	rotate([90, 0, 0])
	union() {
		translate([0, -blower_output_Y, 0])
		cube([blower_output_X, blower_output_Y+blower_Y/2, blower_Z]);
		
		translate([blower_X/2, blower_Y/2, 0])
		union() {
			cylinder(r=blower_X/2, h=blower_Z);
			
			hull() {
				translate([blower_screwpos_X1, blower_screwpos_Y1, 0])
				cylinder(r=4, h=blower_Z);
				translate([blower_screwpos_X2, blower_screwpos_Y2, 0])
				cylinder(r=4, h=blower_Z);
			}
		}
	}
}


// blower mounting plate
module blower_bracket() {
	difference() {
		union() {
			intersection() {
				translate([-100, -100, 0])
				cube([200, 200, blower_bracket_thickness]);
				
				rotate([270, 0, 0])
				blower();
			}
		}
		
		union() {
			
			//blower mounting holes
			translate([blower_X/2, blower_Y/2, 0])
			union() {
				translate([blower_screwpos_X1, blower_screwpos_Y1, 0])
				cylinder(r=3.3/2, h=10, center=true);
				translate([blower_screwpos_X2, blower_screwpos_Y2, 0])
				cylinder(r=3.3/2, h=10, center=true);
			}
			
			//bracket mounting holes
			translate([blower_X/2, blower_Y/2, 0])
			for(i = [0, -15])
			translate([-blower_screwpos/2-1, blower_screwpos/2-25+i, 0])
			union() {
				cylinder(r=blower_bracket_countersunk_d_small/2, h=10, center=true);
				
				translate([0, 0, 0.2])
				cylinder(r1=blower_bracket_countersunk_d_small/2, r2=blower_bracket_countersunk_d_large/2, h=blower_bracket_thickness);
			}
			
			//blower nozzle mounting hole
			translate([blower_output_screw_X, blower_output_screw_Y, 0])
			cylinder(r=3.2/2, h=10, center=true);
		}
	}
}


//blower mounting screws
module blower_mount_screws() {
	rotate([90, 0, 0])
	translate([blower_X/2, blower_Y/2, 0])
	union() {
		translate([blower_screwpos_X1, blower_screwpos_Y1, 0])
		cylinder(r=1.6, h=11, center=true);
		translate([blower_screwpos_X2, blower_screwpos_Y2, 0])
		cylinder(r=1.6, h=11, center=true);
	}
}


//blower mounting plate screws and nuts (2 pcs M3X10 countersunk)
module blower_plate_screws() {
	rotate([0, 0, blower_angle])
	translate([0, -blower_offset_R-blower_mount_dist-0.01, blower_offset_Z])
	translate([-blower_output_X/2, 0, 0])
	union() {
		rotate([90, 0, 0])
		translate([blower_X/2, blower_Y/2, 0])
		for(i = [0, -15]) {
			translate([-blower_screwpos/2-1, blower_screwpos/2-25+i, 0])
			rotate([180, 0, 0])
			union() {
				cylinder(r=1.6, h=10);
				
				translate([0, 0, 4])
				cylinder(h=22+i, r=6.45/2, $fn=6);
			}
		}
	}
}


//Add-on pentant for attaching the blower_bracket();
module blower_attach() {
	rotate([0, 0, blower_angle])
	translate([-blower_output_X/2, -blower_offset_R, blower_offset_Z])
	union() {
		translate([0, -blower_mount_dist, 0])
		hull() {
			cube([blower_output_X/2, 4, fan_pos-blower_offset_Z-blower_mount_height+5]);
			translate([0, blower_mount_dist-0.1, blower_mount_height])
			cube([blower_output_X/2, 0.1, fan_pos-blower_offset_Z-blower_mount_height]);
		}
	}
}


//reinforcement of wall due to screw hole cut-away
module blower_plate_screw_wall() {
	rotate([0, 0, blower_angle])
	translate([-blower_output_X/2, -blower_offset_R, blower_offset_Z])

	rotate([90, 0, 0])
	translate([blower_X/2-blower_screwpos/2-1, blower_Y/2+blower_screwpos/2-25, 10])
	rotate([180, 0, 0])
	cylinder(h=20, r=6.45/2+wall_thin, $fn=6);
}
