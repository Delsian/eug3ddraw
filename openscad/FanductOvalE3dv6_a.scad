/*
 *  Oval Fanduct 
 *  Copyright (C) 2014  Kit Adams
 *  remixed by AndrewBCN _ Barcelona, Spain - November 2014
 *  kept the fan duct shaping code, changed hinge, mount and splitter code
 *  so that it can be used with my fan duct parts Thingiverse # 540716
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
*/

/*
*	Fan duct for active cooling of PLA prints. 
*	Designed to be printed in ABS without support.
*	The intention is that you measure the height from the fan mounting hinge on the extruder
*	to the bottom of the nozzle (in mm) and set the mountToHotEndBottomZ parameter to that value.
*   Then set the bedClearanceGap to the distance above the nozzle you wish the lowest part of the duct to be at.
*
*	Inspired by http://www.thingiverse.com/thing:63123, which I would have used if I could have tweaked it to fit using 
*	OpenSCAD.
*	Uses:
*	 http://www.thingiverse.com/thing:18273, thanks doommeister, and
*	 http://svn.clifford.at/openscad/trunk/libraries/shapes.scad, thanks Catarina Mota.
*/

use <fan_holder_v2.scad>
use <shapes.scad>
use <ruler.scad>

$fn=32;

pi = 3.1416;

mini_r=0.1;
arm_th=3;
fan_screw_hole_pitch=32;

//Important: before generating the stl, change this to the layer height you intend to
//use for printing!

layerHeight = 0.2;    	//Layer height used for printing - Cura OK with this.
//layerHeight = 1;       //Use this (or 2) to speed OpenSCAD up while trying things out

outerRadius = 1.6;      //outer corner radius
wall = 1.5;		//wall thickness

m3_diameter = 3.6;
kFanSize = 40;

/////Settings for E3D V5 hotend and extruder from http://www.thingiverse.com/thing:119616 
heaterBlockW = 18;
nozzleOffsetFromBlockCenter = 2; //+ve if towards mount 
heaterBlockGap = 6;//6; //Horizontal gap between vented tube and heated block - 7 ended up being 6 mm
mountToFilamentHoriz = 21.25; 
fanAngleFromVert = 60;//+5;

//For E3D v6
mountToHotEndBottomZ = 57.5; //vertical distance from center of mounting hinge to tip of nozzl

//For E3Dv5
//mountToHotEndBottomZ = 65; //vertical distance from center of mounting hinge to tip of nozzle.

bedClearanceGap = 10;   //Bottom of each vented duct is this far above the tip of the nozzle.
					    //Something not quite right with this parameter, since I set it to 7mm but it
						//ended up being about 4 mm

//The vented duct reduces in area by changing from oval to round
ventedDuctMaxHeight = 22;
ventedDuctWidth = 16;
endCapDia = 14;
slotAngleFromVertical = 45;//60;
slotWidthDegrees = 60;
///End settings

///////Settings for J-Head V5 hotend and extruder from http://www.thingiverse.com/thing:119616 
//heaterBlockW = 18;
//nozzleOffsetFromBlockCenter = 5; //+ve if towards mount 
//heaterBlockGap = 6; //Horizontal gap between vented tube and heated block - 7 ended up being 6 mm
//mountToFilamentHoriz = 21.25; 
//fanAngleFromVert = 30;
//mountToHotEndBottomZ = 45;//for J-head//65; for E3Dv5; //vertical distance from center of mounting hinge to tip of nozzle.
//bedClearanceGap = 10;   //Bottom of each vented duct is this far above the tip of the nozzle.
//					    //Something not quite right with this parameter, since I set it to 7mm but it
//						//ended up being about 4 mm
////The vented duct reduces in area by changing from oval to round
//ventedDuctMaxHeight = 22;
//ventedDuctWidth = 18;//14;
//endCapDia = 16;
//
//slotAngleFromVertical = 50;//60;
//slotWidthDegrees = 50;
/////End settings

slotMaxWidthFrac = 0.2;

camberAngle = 60;         //Oval part of vented duct is rotated from vertical by this amount (i.e. bottoms inwards).
toeInAngle = 12;          //Increase this to compensate for the air tending to blow forwards more than backwards. 

//Mounting parameters
mountingHingeDia = 8;  
hingeInsideWidth = 7.2;  //width of the hinge block on the extruder from http://www.thingiverse.com/thing:119616
hingeOuterWidth = 4;	  //Thickness of each hinge strut on the fan duct
hingeLen = 4.2;		  //Distance out to the center of the hole



// This is the code to build the fan duct and mount itself (modules come after this)

// fan duct = two mirrored ducts
FanSplitter(mountToHotEndBottomZ,kFanSize,heaterBlockW,ventedDuctMaxHeight,ventedDuctWidth /*,mountToHeatBlockHorizontal*/);
mirror([0,1,0]) FanSplitter(mountToHotEndBottomZ,kFanSize,heaterBlockW,ventedDuctMaxHeight,ventedDuctWidth/*,mountToHeatBlockHorizontal*/);

translate([-outerRadius,-kFanSize/2,-mountingHingeDia]) {
  // Air flow splitter and fan mount
  afsplitter_new();

  //Mounting hinge
  translate([kFanSize/2+1,kFanSize/2,0]) hinge_new();
}	

//-- modules are below this point

module hinge_new() {
  // the hinge - basically three times the same shape
  // and again hull() comes in handy to join everything together
  difference() {
    union() {
      hull() {
	translate([18,-3-3.2,9.1/2-arm_th/2]) cube([1,3,9.1],center=true);
	translate([25,-3-3.2,5]) rotate ([90,0,0]) cylinder(r=4,h=3, center=true);
	translate([26,-3-3.2,0.1/2-arm_th/2]) cube([1,3,0.1],center=true);
      }
      hull() {
	translate([18,0,9.1/2-arm_th/2]) cube([1,3,9.1],center=true);
	translate([25,0,5]) rotate ([90,0,0]) cylinder(r=4,h=3, center=true);
	translate([26,0,0.1/2-arm_th/2]) cube([1,3,0.1],center=true);
      }
      hull() {
	translate([18,3+3.2,9.1/2-arm_th/2]) cube([1,3,9.1],center=true);
	translate([25,3+3.2,5]) rotate ([90,0,0]) cylinder(r=4,h=3, center=true);
	translate([26,3+3.2,0.1/2-arm_th/2]) cube([1,3,0.1],center=true);
      }
    }
    // M3 hole
    translate([25,0,5]) rotate ([90,0,0]) cylinder(r=3.4/2,h=30, center=true);
    //remove anything below base
    translate([0,0,-20]) cube([80,80,40], center=true);
  }
}

//Airflow splitter and fan mount
module afsplitter_new() {
  // air flow splitter: build a hull around four properly placed miniature cylinders
  hull() {
    translate([wall/4,kFanSize/2-0.1,0.2+mini_r]) rotate([0,90,0]) cylinder(r=mini_r, h=kFanSize-wall/2);
    translate([wall/4,kFanSize/2+0.1,0.2+mini_r]) rotate([0,90,0]) cylinder(r=mini_r, h=kFanSize-wall/2);
    translate([wall/4,kFanSize/2-0.8,mountingHingeDia]) rotate([0,90,0]) cylinder(r=mini_r, h=kFanSize-wall/2);
    translate([wall/4,kFanSize/2+0.8,mountingHingeDia]) rotate([0,90,0]) cylinder(r=mini_r, h=kFanSize-wall/2);
  }
  // build an adapter from the circular fan airflow to the square of the walls of the fan mount
  difference() {
    union() {
      translate([wall/2,wall/2,0]) cube([40-wall,40-wall,mountingHingeDia]);
      _fan_mount(
		      fan_size = kFanSize,
		      fan_mounting_pitch = 32,
		      fan_m_hole_dia = 2.5, //For self-tapping M3 screws
		      holder_thickness = mountingHingeDia
		);
    }
    hull() {
      translate([kFanSize/2,kFanSize/2,6]) cylinder(r=37/2,h=mountingHingeDia+0.1-6, $fn=64);
      translate([wall/2-0.1,wall/2-0.1,mountingHingeDia]) cube([40-wall-0.2,40-wall-0.2,0.1]);
    }
    // cleanup
    translate([kFanSize/2,kFanSize/2,-0.1]) cylinder(r=37/2,h=6.2, $fn=64);
    // redo the M3 screw holes
    translate([kFanSize/2+fan_screw_hole_pitch/2,kFanSize/2+fan_screw_hole_pitch/2,-0.1]) cylinder(r=3.4/2, h=mountingHingeDia-2);
    translate([kFanSize/2-fan_screw_hole_pitch/2,kFanSize/2+fan_screw_hole_pitch/2,-0.1]) cylinder(r=3.4/2, h=mountingHingeDia-2);
    translate([kFanSize/2+fan_screw_hole_pitch/2,kFanSize/2-fan_screw_hole_pitch/2,-0.1]) cylinder(r=3.4/2, h=mountingHingeDia-2);
    translate([kFanSize/2-fan_screw_hole_pitch/2,kFanSize/2-fan_screw_hole_pitch/2,-0.1]) cylinder(r=3.4/2, h=mountingHingeDia-2);
    // and hollow out small slots to insert M3 nuts
    translate([1.1,-1,2]) cube([6.1,8,2.8]);
    translate([32.7,-1,2]) cube([6.1,8,2.8]);
    translate([1.1,1+32,2]) cube([6.1,8,2.8]);
    translate([32.7,1+32,2]) cube([6.1,8,2.8]);
  }
}

module FanSplitter(mountToHotEndBottomZ, fanSizeIn = 30, heaterBlockW = 20, smallDuctH = 20, smallDuctW = 12 /*,mountToHeatBlockHorizontal,*/) {
  //Two mirrored versions of this attach to the fan mount and duct the air to the level of the heated block of the hotend.
  fanSize = fanSizeIn-2*outerRadius;
  minAngle = 30;
  ventedDuctsSeparation = heaterBlockW + 2*heaterBlockGap;
  ventedDuctsSeparationMax = ventedDuctsSeparation + sin(toeInAngle)*ventedDuctsSeparation;

  xTrans = cos(fanAngleFromVert)*(mountToHotEndBottomZ-bedClearanceGap)+
	  sin(fanAngleFromVert)*mountingHingeDia/2-
	  hingeLen-fanSizeIn-max(cos(camberAngle)*smallDuctH/2, smallDuctW/2);
  zTrans = tan(minAngle)*xTrans+fanSize/2+smallDuctH/2; //keep the steepest angle >= minAngle deg from x y plane.
  yTrans = ventedDuctsSeparationMax/2 + max(smallDuctW/2, sin(camberAngle)*smallDuctH/2);
  width = fanSize/2;
  nzSteps = zTrans/layerHeight; 
  di = 1/nzSteps;
  stepZ = zTrans*di;
  union()
    {
    for(i=[0:di:1])
	    {
	    assign(width = fanSize/2*(1-i)+i*smallDuctW, height = fanSize*(1-i)+i*smallDuctH )
		    {
	    
		    translate([-xTrans*pow(i,2/*5*/),yTrans*((1-i)*pow(i,1.05)+i*pow(i,0.5)),zTrans*i])
		    difference()
			    {
			    minkowski()
				    {
				    cube([(1-i)*height,(1-i)*width,stepZ]);
				    rotate([0,0,camberAngle])
					    oval(((1-i)*outerRadius+i*height/2),((1-i)*outerRadius+i*width/2),stepZ);
				    }
			    translate([(1-i)*wall,(1-i)*wall,0])
			    scale([(height-2*wall)/height, (width-2*wall)/width,1])
				    minkowski()
					    {
					    cube([(1-i)*height,(1-i)*width,stepZ]);
					    rotate([0,0,camberAngle])
						    oval(((1-i)*outerRadius+i*height/2),((1-i)*outerRadius+i*width/2),stepZ);
					    }
			    }
		    }
	    }
    translate([-xTrans,yTrans,zTrans])
	    mirror([0,1,0])
		    ventedTube(smallDuctH,smallDuctW,0.8*(ventedDuctsSeparation),fanAngleFromVert);
    }
}

module ventedTube(height, width, slotLen, fanAngleFromVert)
{
len = mountToFilamentHoriz+slotLen/2;  //horizontal center of slot should be at nozzle
xTrans = len*sin(fanAngleFromVert)
	-cos(camberAngle)*(height-width)/2; //Compensate for blend from oval to circular below, so as to keep bottom to tube horizontal

yTrans = sin(camberAngle)*(height-width)/2+sin(toeInAngle)*len;

//slotAngle = fanAngleFromVert-atan(0.5*(height-width)/len);

zTrans = len*cos(fanAngleFromVert);
nzSteps = zTrans/layerHeight; 
di = 1/nzSteps;

stepZ = zTrans*di;
r1 = height/2;
r2 = width/2;

//slotWidth = r2*3.1459*45/180; //Corresponds to 45 degrees
slotWidth = r2*pi*slotWidthDegrees/180; //Corresponds to 45 degrees

difference() //Comment this line to see the slot airflow direction
	{ 
	union()
		{
		for(i = [0:di:1])
			{//Blend from oval to circular to reduce volume in a linear fashion
			assign(r1 = (height/2)*(1-i)+i*endCapDia/2,r2 = (width/2)*(1-i)+i*endCapDia/2)
				{
				//translate([xTrans*i,yTrans*(1-cos(i*90)),zTrans*i])
				translate([xTrans*i,yTrans*pow(i,2),zTrans*i])
					rotate([0,0,-camberAngle])
						ovalTube(stepZ,r1,r2,wall);
				}
			}
		//End cap
		translate([xTrans,yTrans,zTrans])
			endCap(endCapDia/2,wall,fanAngleFromVert/2);
		}
		//rotate([0,slotAngle,0]) //Second, rotate the slot to be parallel to the ventedTube
		multmatrix(m = [ [1, 0, xTrans/len, 0],
                 		  [0, 1, (yTrans)/len, 0],
                        [0, 0, 1, 0],
                        [0, 0, 0,  1]
                        ])

			rotate([0,0,90-slotAngleFromVertical])  //First, rotate the slot to point down at an angle of 90 from horizontal
				translate([-slotWidth/2,0,mountToFilamentHoriz-slotLen/2-nozzleOffsetFromBlockCenter])  //horizontal center of slot should be at nozzle])
					{
					hull()
						{
						translate([0,0,1.3*slotMaxWidthFrac*slotLen])
							cube([slotWidth,2*r2,(1-slotMaxWidthFrac)*slotLen-slotWidth]);
						//Add prism at top to avoid need for support
						translate([slotWidth/2,0,slotLen-slotWidth/2])
							cube([0.5,2*r2,0.5*slotWidth]);
						//Add prism at bottom for symmetry
						translate([slotWidth/2,0,-slotWidth/2])
							cube([0.5,2*r2,0.5*slotWidth]);
						}
					}
	}
}

//End cap for the vented ducts
module endCap(r,wall,fanAngleFromVert)
{
len = 1.4*r;
xTrans = len*sin(fanAngleFromVert);
zTrans = len*cos(fanAngleFromVert);
nzSteps = zTrans/layerHeight; 
di = 1/nzSteps;
stepZ = zTrans*di;
r1 = r-wall;
for(i = [0:di:1])
	{
	assign(r1 = (r-wall)*(1-i)+wall)
		{
		translate([xTrans*i,0,zTrans*i])
			ovalTube(stepZ,r1,r1,wall);
		}
	}
}

module coneTube(h, r1, r2, wall, center = false)
{
difference()
	{
	cylinder(h, r1, r2, center);
	cylinder(h, r1-wall, r2-wall, center);
	}
}
