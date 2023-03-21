//@ File(label="Select a destination directory", style="directory") dDir
//@ String(label="Date") date
//@ String(label="Strain:",choices={"WKY0421","WKY0337","WKY0119","WKY0432","WKY0433"}) strain

// Usage: 
// * Destination folder should be called "cropped" and contain two folders named for the two strains used *******
// * Modify "Strain" labels according to project
// (1) Make selections and duplicate ROIs with single cell for analysis with spoquant
// (2) Select the source image, then run macro from the macro editor

// Michael Wozny 2019

// clear up the log window
print("\\Clear");

 //get image ID for current image 
currentImageID = getImageID();

//get total number of open images          
totalOpenImages = nImages;

//create array to hold all image IDs                 
ids = newArray(nImages);

//and populate array with           
for(i = 0 ;i < totalOpenImages; i++){                          
     selectImage(i+1); 
     ids[i]=getImageID(); 
}

//create counter to check whether open image is the source image
sourceImageCounter = 0;

// for the length of the array ids (where the # of strings represents the # of windows)
for (i = 0 ; i < ids.length; i++) {
		// get the ID of the image/window
		selectImage(ids[i]);
		id = getImageID;
		name = getTitle;
		nameLength = lengthOf(name);
		lastDash = lastIndexOf(name, "-");
		dashFromEnd = nameLength - lastDash;
		lastUnderscore = lastIndexOf(name, "_");
		stack = substring(name, lastUnderscore + 1, lastUnderscore + 4);
		if(dashFromEnd < 8) {
			// create a filename for saving the new image
			filename = dDir + File.separator + strain + File.separator + date + "_" + strain + "_" + stack + "_" + (i+1-sourceImageCounter);
			// print in the log window the current file
			print(filename);
			// save the image as a TIFF file
			saveAs("tiff", filename);
			// close image
			selectImage(id); 
			close();
		} 
		else {
		sourceImageCounter = 1;
		}	
}