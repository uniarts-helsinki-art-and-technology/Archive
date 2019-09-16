debug = false
EnableZoneSupport(true)

videoFile1 = "master.mov"
VideoResolution$="1920x1080x50p"

REM Setting Manual IP address
nc = CreateObject("roNetworkConfiguration", 0)
nc.SetIP4Address("192.168.1.10")
nc.SetIP4Netmask("255.255.255.0")
nc.SetIP4Broadcast("192.168.1.255")
nc.SetIP4Gateway("192.168.1.1")
nc.Apply()


REM IP address 255.255.255.255 sends to all units
sender = CreateObject("roDatagramSender")
sender.SetDestination("255.255.255.255", 11167)


REM Create some BrightScript objects
v = CreateObject("roVideoPlayer")
gpio = CreateObject("roGpioControlPort")
myPort = CreateObject("roMessagePort")
mode = CreateObject("roVideoMode")
gpio.EnableOutput(1) 
gpio.EnableOutput(2) 

REM set videoPlayer, videoMode
v.SetPort(myPort)
REM v.SetLoopMode(true)
v.SetVolume(50)
mode.SetMode(VideoResolution$)

REM new variable
pvid = 0

sleep(5000)


REM create "start" label
start:

	gpio.SetOutputState(1,1)

		sender.Send("1")
		v.PreloadFile(videoFile1)
		sleep(500)
		gpio.SetOutputState(1,0)

	
REM play the video
	sender.Send("2")
	v.Play()
	sleep(100)


REM create "listen" label
listen:

	msg = wait(2000,myPort)

	if type(msg) = "roVideoEvent" and msg.GetInt() = 8 then
	    sleep(1000)
		goto start
	endif

	REM go back to listen label
	goto listen
