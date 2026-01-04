function init() as void
    m.top.backgroundColor = "#000000"
    m.top.title = "Main Scene"
    
	cryptoArray = []
	cryptoJson = { "BTC":"Bitcoin", "ETH":"Ethereum" }
	
	for each key in cryptoJson
    	item = { id: key, name: cryptoJson[key] }
    	cryptoArray.push(item)
	end for
    ' Initialize other components or variables here
	pageSize = 5
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

    ' return data[startIndex:endIndex]
    return []
end function



sub LoadTop10()
    task = CreateObject("roSGNode", "Top10Task")
    task.url = "https://www.nerdjewels.com/top10.json"

    task.ObserveField("status", "OnTop10Loaded")
    task.control = "run"
end sub

sub OnTop10Loaded()
    task = m.top10Task

    if task.status = "success"
        top10AA = task.result
        ?"TOP 10 DATA LOADED:"
        ? top10AA
    else
        ?"ERROR LOADING TOP 10:"; task.status
    end if
end sub


