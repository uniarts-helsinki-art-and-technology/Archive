# Heidi's project

Based on 2 Raspberry Pi and a PIR sensor
The Pies are connect with an ethernet cable

OMX player is used to playback the videos, python OSC to let the Pies communicate with eacjother in a master-slave fashion. Two Processing sketches establish the logic of the playback, looping and cueing the video and send command to the omxplayer via python script.
