EnableZoneSupport(true)

videoFile1 = "slave.mov"

mode=CreateObject("roVideoMode")
mode.SetMode("1920x1080x50p")

REM
REM Setting Manual IP address
REM To use DHCP, add REM before each of the nc.SetIP* lines below.
REM If you have already run the script, also remove REM from the
REM nc.SetDHCP() line below to change from manual IP back

nc = CreateObject("roNetworkConfiguration", 0)
REM nc.SetDHCP() 'to change from Manual IP back to DHCP

nc.SetIP4Address("192.168.1.11")
nc.SetIP4Netmask("255.255.255.0")
nc.SetIP4Broadcast("192.168.1.255")
nc.SetIP4Gateway("192.168.1.1")
nc.Apply()

receiver = CreateObject("roDatagramReceiver", 11167)

v = CreateObject("roVideoPlayer")
sleep(200)

v.PreloadFile(videoFile1)
sleep(200)

p = CreateObject("roMessagePort")
v.Play()

receiver.SetPort(p)


listen:
	msg = wait(2000,p)

	if type(msg) = "roDatagramEvent" then
        
	command = left(msg, 3)

		if command = "1" then
				v.PreloadFile(videoFile1)
		endif
		if command = "2" then
				v.Play()
		endif
			REM print msg
		

	endif

	goto listen
