# Jenni's project

Video synchronisation of 3 video files based on Processing application runnig on Mac Mini.

## Installation:

1. Download scripts and install Processing (www.processing.org) for all computers

## 2. Setup "master":

2. 1. Set correct address for myRemoteLocation(s) See line(s): myRemoteLocation1 = new NetAddress("169.254.207.133", 12000); etc.

2. 2. Set the crrect file path pointing to your video file. See line:  movie = new Movie(this, "/Users/exlabadmin/Desktop/master_video.mov");

2. 3. Export Processing app.


## 3. Setup "slave(s)":

3. 1. Set the crrect file path pointing to your video file. See line:  movie = new Movie(this, "/Users/KuvaTila1/Desktop/slaveVideo.mov");

4. Connect the computers with LAN cable (and router if needed)

5. Run the exported app on both computers. The synching will start on the second loop.
