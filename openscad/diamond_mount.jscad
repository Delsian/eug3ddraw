
include ("DiamondParts.jscad");

// Here we define the user editable parameters: 
function getParameterDefinitions() {
	return [
		{
			name: 'pFanSize',
			type: 'choice',
			caption: 'Size of print fan:',
			values: [40, 50],
			initial: 40
		},
		{
			name: 'assembled',
			type: 'choice',
			caption: 'Assembled view:',
			values: [0, 1],
			captions: ["No", "Yes"],
			initial: 0
		},		
		{ name: 'heaterBlockW', caption: 'heater Block Width:', type: 'float', initial: 18 },
		{ name: 'wall', caption: 'Wall Width:', type: 'float', initial: 2 }
	];
}




tolerance = 0.1;				// plastic/metal parts fitting tolerance
fanAngleFromVert = 60;
ventedDuctMaxHeight = 22;
ventedDuctWidth = 16;
mountToHotEndBottomZ = 57.5; //vertical distance from center of mounting hinge to tip of nozzl


function main(params) {

	var end;
	var dp = DiamondParts();
	
	if (params.assembled == 1) {
		end = union (
			DiamondParts().ColdEnd(),
			hotend()
		);
	} else {
		end = dp.ColdEnd();
	}
	return union(
		difference(
			union(
				retention(),
				deflectors(),
				duct(),
				mounting()
			),
			union(
				end,
				wirehole(),
				fan_mount_holes()
			)
		),

		rotate([0,-(90+fanAngleFromVert),180],
			fanduct_all())
	);
}

function fanduct_all() {
	return union (
		FanSplitter(mountToHotEndBottomZ,
	        kFanSize,heaterBlockW,
	        ventedDuctMaxHeight,ventedDuctWidth
	        /*,mountToHeatBlockHorizontal*/),
	    mirror([0,1,0],
	        FanSplitter(mountToHotEndBottomZ, kFanSize,
	            heaterBlockW, ventedDuctMaxHeight,
	            ventedDuctWidth
	            /*,mountToHeatBlockHorizontal*/)),
	
	    translate([-wall, -kFanSize/2, -8],
	        afsplitter_new()),
	    translate([kFanSize/2+1, 0, -8],
	        hinge_new())
	);
}


