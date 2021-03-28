// Define channel to measure and what it represents
ch_1 = 1
ch_1_label = "hes6"
ch_2 = 3
ch_2_label = "tfap2b"

roi_dir = getDirectory("home")+"Desktop//20210305_Analysis//rois//"
csv_dir = getDirectory("home")+"Desktop//20210305_Analysis//csvs//"


// Learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
rename("A");
setTool("freehand");

// Project and rotate image, if necessary
run("Z Project...", "projection=[Max Intensity]");
run("Flip Horizontally", "stack");

//Rotate image to horizontal or vertical
setSlice(1);
run("Enhance Contrast", "saturated=0.35");
setSlice(3);
run("Enhance Contrast", "saturated=0.35");
run("Magenta");
waitForUser("Rotate image until horizontal or vertical, then press ok");

//Add scale bar to define AP length for measurement
run("Scale Bar...", "width=400 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");

//Close unnecessary windows from last analysis
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); 
    } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); 
    } 
if (isOpen("ROI Manager")) { 
         selectWindow("ROI Manager"); 
         run("Close"); 
    } 

//Optional: Input ROI File:
//	roi=File.openDialog("Select ROI file");
//	roiManager("Open",roi);

//Define ROIs Manually (background, experimental and control sides)
waitForUser("Draw BACKGROUND ROI, then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","background");
roiManager("Show All");
waitForUser("Draw EXPERIMENTAL ROI, then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","Expt");
waitForUser("Draw CONTROL ROI, then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","Cntl");

//Measure background then ROI IntDen
Stack.setChannel(ch_1);
rename(ch_1_label);
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 1);
run("Measure");
Stack.setChannel(ch_2);
rename(ch_2_label);
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 1);

//Save out ROIs
roiManager("Save", roi_dir+name+".zip");

//Save out Measurements as csv
saveAs("Results", csv_dir+name+".csv");

//Close image windows
run("Close All");