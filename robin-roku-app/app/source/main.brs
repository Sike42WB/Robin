Library "v30/bslDefender.brs"

function Main(launchParameters)
	GetGlobalAA().mainPort = createObject("roMessagePort")
	gaa = mergeManifestLaunchParams(launchParameters)

    runApplication(gaa, launchParameters)

end function

function runApplication(gaa as object, launchParameters as object)

	gaa.phxDelayedEvents = [createAPPLaunchEvent()]

	if gaa.launchApp = "1.0" then
		new_main(gaa, launchParameters)
	else
		?"Unknown "; gaa.launchApp; " app."
	end if
end function

function createAPPLaunchEvent() as object
	dt = createObject("roDateTime")
	eventOccured& = dt.AsSeconds()
	eventOccured& = eventOccured& * 1000 + dt.GetMilliseconds()

	appLaunchEvent = {
		"eventCategory": "launch",
		"eventName": "appLaunch",
		"eventData": {
			"eventOccurredTimestamp": eventOccured&
		}
	}

	return appLaunchEvent
end function
