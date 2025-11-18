function mergeManifestLaunchParams(launchParameters)
	gaa = GetGlobalAA()
	appInfo = createObject("roAppInfo")
	gaa.stage = appInfo.getValue("robin_stage")
	gaa.launchApp = lcase(appInfo.getValue("robin_launch_app"))
	gaa.environment = ucase(appInfo.getValue("robin_environment"))
	gaa.phxEnvironment = ucase(appInfo.getValue("phx_env"))
	gaa.robinRegion = ucase(appInfo.getValue("robin_region"))
	gaa.robinGitCommit = appInfo.getValue("robin_git_commit")
    gaa.unitTestingEnabled = appInfo.getValue("robin_enableUnitTesting")
	?"PHX_ENV = "; gaa.phxEnvironment
	?"ROBIN_REGION = "; gaa.robinRegion
	?"ROBIN_GITCOMMIT = "; gaa.robinGitCommit
    ?"gaa.unitTestingEnabled ："; type(gaa.unitTestingEnabled)
	for each item in launchParameters.items()
		gaa[item.key] = item.value
	end for

	' Forcing staging if requested
	if gaa.staging <> invalid and gaa.staging = "true" then
		gaa.staging = true
		gaa.environment = "staging"
	else
		gaa.staging = false
	end if

	return gaa
end function

sub GlobalSet(key as string, entity as dynamic)
    if (type(entity) = invalid) 
        print "*** ERROR *** Utilities : GlobalSet : invalid entity"
    else
        if (m.global.hasField(key))
            m.global.setField(key, entity)
        else
            obj = {}
            obj[key] = entity
            m.global.addFields(obj)
        end if
    end if
end sub

function GlobalGet(key as string, default=invalid as dynamic) as dynamic
    if (m.global.hasField(key))
        return m.global.getField(key)
    else
        return default
    end if
end function