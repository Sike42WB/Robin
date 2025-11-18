function init() as void
    m.top.backgroundColor = "#000000"
    m.top.title = "Main Scene"
    
    ' Initialize other components or variables here

		m.theme = GlobalGet("Theme")
		m.InitConfigs = GlobalGet("InitConfigs")

		m.ViewStackManager = CreateViewStackManager()
		m.RegistryManager = CreateRegistryManager()

		m.top.backgroundURI = "pkg:/images/wbtvd-roku-bg.png"

		m.appLaunchCompleteBeaconSent = false
		m.appDialogInitiateBeaconSent = false
		m.appDialogCompleteBeaconSent = false

		UpdateLanguage()
		UpdateEnvironment()
	  	ChangeFonts()

		GlobalSet("BrainiacPartnerID",m.InitConfigs.BrainiacPartnerID)



end function