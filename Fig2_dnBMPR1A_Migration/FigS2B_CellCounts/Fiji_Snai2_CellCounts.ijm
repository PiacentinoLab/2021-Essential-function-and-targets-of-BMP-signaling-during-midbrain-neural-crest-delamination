/////////////////Set Up Analysis/////////////////
// Define channel to measure and what it represents
ch_measure = 1
ch_label = "Snai2"
roi_dir = getDirectory("home")+"Drive//Data//20210516_dnBMPR1A_revisionIHC//sections//rois//"
csv_dir = getDirectory("home")+"Drive//Data//20210516_dnBMPR1A_revisionIHC//sections//csvs//"

//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
Stack.setChannel(ch_measure);
//run("Z Project...", "projection=[Max Intensity]");
setTool("freehand");

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

//Input ROI File (un-comment out following two lines and remove block below that):
//roi=File.openDialog("Select ROI file");
//roi=roi_dir+name+".zip";
//roiManager("Open",roi);

//Define ROIs (experimental and control sides)
roiManager("Show All");
waitForUser("Draw EXPERIMENTAL ROI, then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","Expt");
waitForUser("Draw CONTROL ROI, then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","Cntl");
run("Split Channels");

/////////////////First channel/////////////////
//Set images for analysis
selectWindow("C"+ch_measure+"-A");

/////////////////Analyze cell counts/////////////////
resetMinAndMax();
//setMinAndMax(75, 150);
run("Median...", "radius=3 slice");
run("8-bit");
roiManager("show all");
run("Auto Local Threshold", "method=Phansalkar radius=20 parameter_1=0 parameter_2=0 white");
run("Analyze Particles...", "size=5.00-Infinity show=Masks");
run("Invert LUT");
rename("CntlSide");
run("Duplicate...", "title=ExptSide");

selectWindow("CntlSide");
roiManager("Show All");
roiManager("Select", 1);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

selectWindow("ExptSide");
roiManager("Show All");
roiManager("Select", 0);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

/////////////////Save out results/////////////////
//Save out CSVs
saveAs("Results", csv_dir+name+"_"+ch_label+".csv");

//Save out ROIs
roiManager("Save", roi_dir+name+".zip");

//Close image windows
run("Close All");