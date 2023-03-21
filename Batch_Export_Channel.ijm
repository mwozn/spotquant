//@ File(label="Select a source directory", style="directory") sDir
//@ File(label="Select a destination directory", style="directory") dDir
//@ String(label="Input image type:",choices={".nd2",".tif"}) rawFileType
//@ String(label="Channel index") channel
//@ String(label="channel tag") tag
//
// Jerome Boulanger 2019 for Michael Wozny (adapted by Michael Wozny 2019)
// Usage:
// (1) Use Save_All_Open_Images.ijm to save duplicates of subregions containing cells 
// (2) Use Batch_Export_Channel.ijm for single channel stacks for analysis with spotquant 

macro "Batch Export Channel" {
	// clear up the log window
	print("\\Clear");
	//set batch mode to hide all images windows while processing
	setBatchMode(true);	
	// get the list of files in the source directory sDir (returns an array)
	fileslist = getFileList(sDir);	
	// for each string in the array
	for (i = 0; i < fileslist.length; i++) {
		// if the string ends with rawFileType
		if (endsWith(fileslist[i],rawFileType)) {
			// create a filename by concatenating folder, the file separator and the ith string (filename) in the array
			sfilename = sDir + File.separator + fileslist[i];
			// print in the log window the current file
			print(sfilename); 
			// load the file in imagej/ in memory
			open(sfilename);
			// get the ID of the image/window
			id1 = getImageID;
			// select a channel -> create a new image
			run("Make Substack...", "channels="+channel);
			// get the ID of the new image
			id2 = getImageID; 
			// create a filename for saving the new image
			dfilename = dDir + File.separator + appendToFilename(fileslist[i], tag);	
			// save the image as a TIFF file
			saveAs("TIFF",dfilename);		
			// close windows 
			selectImage(id2); close();
			selectImage(id1); close();						
		}
	}
	setBatchMode(false);
}

// append str before the extension of filename
function appendToFilename(filename, str) {
	i = lastIndexOf(filename, '.');
	if (i > 0) {
		name = substring(filename, 0, i);
		ext = substring(filename, i, lengthOf(filename));
		return name + str + ext;
	} else {
		return filename + str
	}
}