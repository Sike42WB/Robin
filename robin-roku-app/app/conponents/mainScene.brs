function init() as void
    m.top.backgroundColor = "#000000"
    m.top.title = "Main Scene"
    
	cryptoArray = []
	for each key in cryptoJson
    	item = { id: key, name: cryptoJson[key] }
    	cryptoArray.push(item)
	end for
    ' Initialize other components or variables here
	pageSize = 50
	currentPage = 0
	rowData = getPage(cryptoArray, currentPage, pageSize)

	'	m.theme = GlobalGet("Theme")
	'	m.InitConfigs = GlobalGet("InitConfigs")

	'	m.ViewStackManager = CreateViewStackManager()
	'	m.RegistryManager = CreateRegistryManager()

		m.top.backgroundURI = "pkg:/images/robin-roku-bg.png"

		m.appLaunchCompleteBeaconSent = false
		m.appDialogInitiateBeaconSent = false
		m.appDialogCompleteBeaconSent = false

	'	UpdateLanguage()
	'	UpdateEnvironment()
	 ' 	ChangeFonts()
end function


function getPage(data as Object, page as Integer, pageSize as Integer) as Object
    startIndex = page * pageSize
    endIndex = startIndex + pageSize
    if endIndex > data.count()
        endIndex = data.count()
    end if

    return data[startIndex:endIndex]
end function
