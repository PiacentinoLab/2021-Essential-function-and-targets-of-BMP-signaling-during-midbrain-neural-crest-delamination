// Define channel to mask
ch_mask = 1
roi_dir = getDirectory("home")+"Desktop//rois//"
csv_dir = getDirectory("home")+"Desktop//csvs//"

//Close unnecessary windows from last analysis
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); } 
if (isOpen("ROI Manager")) { 
         selectWindow("ROI Manager"); 
         run("Close");} 

// Learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
print("Processing: " + name);
rename("A");
setMinAndMax(0, 65535);
call("ij.ImagePlus.setDefault16bitRange", 16);
setTool("freehand");
run("Options...", "iterations=1 count=1 black do=Nothing");

// Project and rotate image, if necessary
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
run("Out [-]");

// Find desired slice to process
Stack.setDisplayMode("composite");
//waitForUser("Find desired z-slice, then press ok");
Stack.getPosition(channel, slice, frame);
run("Duplicate...", "title=A-slice duplicate slices=" + slice);

//Make Masks
run("Duplicate...", "title=A-slice-forMask duplicate channels=" + ch_mask);
resetMinAndMax();
run("Enhance Contrast...", "saturated=0.01");
run("Out [-]");
run("Median...", "radius=2");
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Threshold", "method=MaxEntropy white");
run("Watershed");
run("Analyze Particles...", "size=15-Infinity show=Masks");
rename("Pax7_Mask");
run("Invert LUT");

// Close some unnecessary images
selectWindow("A");
run("Close");
selectWindow("A-slice-forMask");
run("Close");

// Measurements of the background
selectWindow("A-slice");
run("Enhance Contrast", "saturated=0.01");
waitForUser("Draw BACKGROUND ROI, then press ok");
roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", "background");
Stack.setChannel(1);
roiManager("Measure");
Stack.setChannel(2);
roiManager("Measure");
Stack.setChannel(3);
roiManager("Measure");
saveAs("Results", csv_dir+name+"_background.csv");
roiManager("Save", roi_dir+name+"_background.zip");
roiManager("Deselect");
roiManager("Delete");

//Close unnecessary windows from last analysis
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); } 
if (isOpen("ROI Manager")) { 
         selectWindow("ROI Manager"); 
         run("Close");} 

// Measurements in the premigratory NC cells
selectWindow("A-slice");
Stack.setChannel(1);
waitForUser("Draw Premigratory NC ROI, then press ok");
roiManager("Add");
selectWindow("Pax7_Mask");
roiManager("Select", 0);
roiManager("Rename", "pNC");
run("Analyze Particles...", "size=10-Infinity show=Nothing add");
roiManager("Deselect");
selectWindow("A-slice");
Stack.setChannel(1);
roiManager("Measure");
Stack.setChannel(2);
roiManager("Measure");
Stack.setChannel(3);
roiManager("Measure");
saveAs("Results", csv_dir+name+"_pNC.csv");
roiManager("Save", roi_dir+name+"_pNC.zip");
roiManager("Deselect");
roiManager("Delete");

//Close unnecessary windows from last analysis
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); } 
if (isOpen("ROI Manager")) { 
         selectWindow("ROI Manager"); 
         run("Close");} 

// Measurements in the migratory NC cells
selectWindow("A-slice");
Stack.setChannel(1);
waitForUser("Draw Migratory NC ROI, then press ok. If no mNC cells, don't draw and move along.");
roiManager("Add");
selectWindow("Pax7_Mask");
roiManager("Select", 0);
roiManager("Rename", "mNC");
run("Analyze Particles...", "size=10-Infinity show=Nothing add");
roiManager("Deselect");
selectWindow("A-slice");
Stack.setChannel(1);
roiManager("Measure");
Stack.setChannel(2);
roiManager("Measure");
Stack.setChannel(3);
roiManager("Measure");
saveAs("Results", csv_dir+name+"_mNC.csv");
roiManager("Save", roi_dir+name+"_mNC.zip");
roiManager("Deselect");
roiManager("Delete");

//Close unnecessary windows from last analysis
run("Close All");
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); } 
if (isOpen("ROI Manager")) { 
         selectWindow("ROI Manager"); 
         run("Close");} 